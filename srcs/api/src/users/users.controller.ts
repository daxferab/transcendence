import {
  Controller,
  Post,
  Get,
  Put,
  Patch,
  Body,
  Param,
  Req,
  HttpCode,
  HttpStatus,
  UseGuards,
  UseInterceptors,
  UploadedFile,
  BadRequestException,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';
import { mkdirSync } from 'fs';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { LoginUserDto } from './dto/login-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { AuthGuard, AuthenticatedRequest } from '../auth/auth.guard';

const AVATAR_UPLOAD_DIR = './uploads/avatars';

const avatarStorage = diskStorage({
  destination: (_req, _file, cb) => {
    mkdirSync(AVATAR_UPLOAD_DIR, { recursive: true });
    cb(null, AVATAR_UPLOAD_DIR);
  },
  filename: (req: any, file, cb) => {
    const userId = req.user?.id || req.params?.username || req.params?.id || 'user';
    const ext = extname(file.originalname) || '.png';
    cb(null, `${userId}-${Date.now()}${ext}`);
  },
});

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  // GET /api/users/me (Current logged-in user's profile)
  @Get('me')
  @UseGuards(AuthGuard)
  async getMe(@Req() req: AuthenticatedRequest) {
    return this.usersService.toPublicProfile(req.user);
  }

  // PUT /api/users/me (Update own profile info)
  @Put('me')
  @UseGuards(AuthGuard)
  async updateMe(
    @Req() req: AuthenticatedRequest,
    @Body() updateUserDto: UpdateUserDto,
  ) {
    return this.usersService.updateProfile(req.user.id, updateUserDto);
  }

  // POST /api/users/me/avatar (Upload avatar for logged-in user)
  @Post('me/avatar')
  @UseGuards(AuthGuard)
  @UseInterceptors(FileInterceptor('avatar', { storage: avatarStorage }))
  async uploadMyAvatar(
    @Req() req: AuthenticatedRequest,
    @UploadedFile() file: { filename: string },
  ) {
    if (!file) {
      throw new BadRequestException('No avatar file uploaded (expected field "avatar")');
    }
    const avatarUrl = `/api/uploads/avatars/${file.filename}`;
    return this.usersService.updateAvatar(req.user.id, avatarUrl);
  }

  // POST /api/users/register
  @Post('register')
  async register(@Body() createUserDto: CreateUserDto) {
    return this.usersService.register(createUserDto);
  }

  // POST /api/users/login
  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(@Body() loginUserDto: LoginUserDto) {
    return this.usersService.login(loginUserDto);
  }

  // POST /api/users/:username/logout
  @Post(':username/logout')
  @HttpCode(HttpStatus.OK)
  async logout(@Param('username') username: string) {
    return this.usersService.logout(username);
  }

  // GET /api/users
  @Get()
  async findAll() {
    return this.usersService.findAll();
  }

  // GET /api/users/:username (Public profile page)
  @Get(':username')
  async findByUsername(@Param('username') username: string) {
    return this.usersService.findById(username);
  }

  // PATCH /api/users/:username (Update profile info by username)
  @Patch(':username')
  async updateProfile(
    @Param('username') username: string,
    @Body() updateUserDto: UpdateUserDto,
  ) {
    return this.usersService.updateProfile(username, updateUserDto);
  }

  // POST /api/users/:username/avatar (Upload avatar by username)
  @Post(':username/avatar')
  @UseInterceptors(FileInterceptor('avatar', { storage: avatarStorage }))
  async uploadAvatar(
    @Param('username') username: string,
    @UploadedFile() file: { filename: string },
  ) {
    if (!file) {
      throw new BadRequestException('No avatar file uploaded (expected field "avatar")');
    }
    const avatarUrl = `/api/uploads/avatars/${file.filename}`;
    return this.usersService.updateAvatar(username, avatarUrl);
  }
}
