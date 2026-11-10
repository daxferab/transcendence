import {
  Injectable,
  ConflictException,
  UnauthorizedException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { LoginUserDto } from './dto/login-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';

export interface PublicUserProfile {
  id: string;
  name: string;
  contact: string;
  bio: string;
  avatarUrl: string;
  isOnline: boolean;
  xp: number;
  level: number;
  currentStreak: number;
  lastFocusDate: string | null;
  createdAt: Date;
}

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
  ) {}

  // Strips internalId and password before returning data over HTTP
  toPublicProfile(user: User): PublicUserProfile {
    return {
      id: user.id,
      name: user.name,
      contact: user.contact,
      bio: user.bio,
      avatarUrl: user.avatarUrl,
      isOnline: user.isOnline,
      xp: user.xp,
      level: user.level,
      currentStreak: user.currentStreak,
      lastFocusDate: user.lastFocusDate,
      createdAt: user.createdAt,
    };
  }

  // Internal helper for AuthService & other services to create a User row
  async createEntity(createUserDto: CreateUserDto): Promise<User> {
    const existing = await this.usersRepository.findOne({
      where: { id: createUserDto.id },
    });

    if (existing) {
      throw new ConflictException(`User with id '@${createUserDto.id}' already exists`);
    }

    const newUser = this.usersRepository.create(createUserDto);
    return this.usersRepository.save(newUser);
  }

  // Internal helper for AuthService to verify credentials
  async verifyCredentials(loginUserDto: LoginUserDto): Promise<User> {
    const user = await this.usersRepository.findOne({
      where: { id: loginUserDto.id },
    });

    if (!user || user.password !== loginUserDto.password) {
      throw new UnauthorizedException('Invalid id or password');
    }

    return user;
  }

  // Internal helper to find raw User entity by @id
  async findEntityById(id: string): Promise<User> {
    const user = await this.usersRepository.findOne({ where: { id } });
    if (!user) {
      throw new NotFoundException(`User '@${id}' not found`);
    }
    return user;
  }

  // Internal helper to save updated User entity
  async saveEntity(user: User): Promise<User> {
    return this.usersRepository.save(user);
  }

  // Register a new user
  async register(createUserDto: CreateUserDto): Promise<PublicUserProfile> {
    const savedUser = await this.createEntity(createUserDto);
    return this.toPublicProfile(savedUser);
  }

  // Login / Access verification
  async login(loginUserDto: LoginUserDto): Promise<{ message: string; user: PublicUserProfile }> {
    const user = await this.verifyCredentials(loginUserDto);
    user.isOnline = true;
    const savedUser = await this.usersRepository.save(user);

    return {
      message: 'Access granted',
      user: this.toPublicProfile(savedUser),
    };
  }

  // Logout
  async logout(id: string): Promise<{ message: string }> {
    const user = await this.findEntityById(id);
    user.isOnline = false;
    await this.usersRepository.save(user);
    return { message: 'Logged out' };
  }

  // Get public profile by @username
  async findById(id: string): Promise<PublicUserProfile> {
    const user = await this.findEntityById(id);
    return this.toPublicProfile(user);
  }

  // List all users (ordered by XP descending by default)
  async findAll(): Promise<PublicUserProfile[]> {
    const users = await this.usersRepository.find({
      order: { xp: 'DESC' },
    });
    return users.map((user) => this.toPublicProfile(user));
  }

  // Update profile information (name, contact, bio, password)
  async updateProfile(id: string, updateUserDto: UpdateUserDto): Promise<PublicUserProfile> {
    const user = await this.findEntityById(id);

    if (updateUserDto.name !== undefined) user.name = updateUserDto.name;
    if (updateUserDto.contact !== undefined) user.contact = updateUserDto.contact;
    if (updateUserDto.bio !== undefined) user.bio = updateUserDto.bio;
    if (updateUserDto.password !== undefined) user.password = updateUserDto.password;

    const savedUser = await this.usersRepository.save(user);
    return this.toPublicProfile(savedUser);
  }

  // Update user avatar URL after file upload
  async updateAvatar(id: string, avatarUrl: string): Promise<PublicUserProfile> {
    const user = await this.findEntityById(id);
    user.avatarUrl = avatarUrl;
    const savedUser = await this.usersRepository.save(user);
    return this.toPublicProfile(savedUser);
  }
}
