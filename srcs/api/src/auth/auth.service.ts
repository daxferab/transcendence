import {
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { randomBytes } from 'crypto';
import { Request, Response } from 'express';
import { AuthSession } from './entities/auth-session.entity';
import { UsersService, PublicUserProfile } from '../users/users.service';
import { CreateUserDto } from '../users/dto/create-user.dto';
import { LoginUserDto } from '../users/dto/login-user.dto';
import { User } from '../users/entities/user.entity';

export const SESSION_COOKIE_NAME = 'sf_session';
const SESSION_TTL_MS = 7 * 24 * 60 * 60 * 1000; // 7 days

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(AuthSession)
    private readonly sessionsRepository: Repository<AuthSession>,
    private readonly usersService: UsersService,
  ) {}

  // Helper: creates a session row in PostgreSQL and sets an HttpOnly cookie on the response
  private async createSession(user: User, res: Response): Promise<string> {
    const token = randomBytes(32).toString('hex');
    const expiresAt = new Date(Date.now() + SESSION_TTL_MS);

    const session = this.sessionsRepository.create({
      token,
      user,
      expiresAt,
    });
    await this.sessionsRepository.save(session);

    res.cookie(SESSION_COOKIE_NAME, token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: SESSION_TTL_MS,
      path: '/',
    });

    return token;
  }

  // Extract token from HttpOnly cookie OR Authorization: Bearer <token> header
  extractTokenFromRequest(req: Request): string | null {
    const cookieHeader = req.headers.cookie;
    if (cookieHeader) {
      const pairs = cookieHeader.split(';');
      for (const pair of pairs) {
        const [rawKey, ...rawVal] = pair.trim().split('=');
        if (rawKey === SESSION_COOKIE_NAME) {
          return decodeURIComponent(rawVal.join('='));
        }
      }
    }

    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith('Bearer ')) {
      return authHeader.slice(7).trim();
    }

    return null;
  }

  // Validate token and return the authenticated User entity
  async validateRequest(req: Request): Promise<User> {
    const token = this.extractTokenFromRequest(req);
    if (!token) {
      throw new UnauthorizedException('Not authenticated (missing session cookie or Bearer token)');
    }

    const session = await this.sessionsRepository.findOne({
      where: { token },
    });

    if (!session || session.expiresAt.getTime() < Date.now()) {
      if (session) {
        await this.sessionsRepository.delete({ token });
      }
      throw new UnauthorizedException('Session expired or invalid');
    }

    return session.user;
  }

  // POST /api/auth/register
  async register(
    createUserDto: CreateUserDto,
    res: Response,
  ): Promise<{ message: string; token: string; user: PublicUserProfile }> {
    const userEntity = await this.usersService.createEntity(createUserDto);
    userEntity.isOnline = true;
    await this.usersService.saveEntity(userEntity);

    const token = await this.createSession(userEntity, res);

    return {
      message: 'Registered and logged in',
      token,
      user: this.usersService.toPublicProfile(userEntity),
    };
  }

  // POST /api/auth/login
  async login(
    loginUserDto: LoginUserDto,
    res: Response,
  ): Promise<{ message: string; token: string; user: PublicUserProfile }> {
    const userEntity = await this.usersService.verifyCredentials(loginUserDto);
    userEntity.isOnline = true;
    await this.usersService.saveEntity(userEntity);

    const token = await this.createSession(userEntity, res);

    return {
      message: 'Access granted',
      token,
      user: this.usersService.toPublicProfile(userEntity),
    };
  }

  // POST /api/auth/logout
  async logout(req: Request, res: Response): Promise<{ message: string }> {
    const token = this.extractTokenFromRequest(req);
    if (token) {
      const session = await this.sessionsRepository.findOne({ where: { token } });
      if (session?.user) {
        session.user.isOnline = false;
        await this.usersService.saveEntity(session.user);
      }
      await this.sessionsRepository.delete({ token });
    }

    res.clearCookie(SESSION_COOKIE_NAME, { path: '/' });
    return { message: 'Logged out' };
  }
}

