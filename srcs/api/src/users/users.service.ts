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

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
  ) {}

  // Register a new user
  async register(createUserDto: CreateUserDto): Promise<Omit<User, 'password' | 'internalId'>> {
    const existing = await this.usersRepository.findOne({
      where: { id: createUserDto.id },
    });

    if (existing) {
      throw new ConflictException(`User with id '@${createUserDto.id}' already exists`);
    }

    const newUser = this.usersRepository.create(createUserDto);
    const savedUser = await this.usersRepository.save(newUser);

    // Return the user tuple without exposing internalId or password
    const { password, internalId, ...result } = savedUser;
    return result;
  }

  // Login / Access verification
  async login(loginUserDto: LoginUserDto): Promise<{ message: string; user: Omit<User, 'password' | 'internalId'> }> {
    const user = await this.usersRepository.findOne({
      where: { id: loginUserDto.id },
    });

    if (!user || user.password !== loginUserDto.password) {
      throw new UnauthorizedException('Invalid id or password');
    }

    const { password, internalId, ...result } = user;
    return {
      message: 'Access granted',
      user: result,
    };
  }

  // Get a user profile by @id
  async findById(id: string): Promise<Omit<User, 'password' | 'internalId'>> {
    const user = await this.usersRepository.findOne({
      where: { id },
    });

    if (!user) {
      throw new NotFoundException(`User '@${id}' not found`);
    }

    const { password, internalId, ...result } = user;
    return result;
  }

  // List all users (public profile tuple)
  async findAll(): Promise<Array<Omit<User, 'password' | 'internalId'>>> {
    const users = await this.usersRepository.find();
    return users.map(({ password, internalId, ...rest }) => rest);
  }
}

