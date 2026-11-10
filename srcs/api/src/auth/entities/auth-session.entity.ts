import {
  Entity,
  PrimaryColumn,
  ManyToOne,
  CreateDateColumn,
  Column,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity('auth_sessions')
export class AuthSession {
  @PrimaryColumn()
  token: string; // Random 64-char hex session token

  @ManyToOne(() => User, { onDelete: 'CASCADE', eager: true })
  user: User;

  @CreateDateColumn()
  createdAt: Date;

  @Column({ type: 'timestamp' })
  expiresAt: Date;
}

