import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
} from 'typeorm';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  internalId: number;

  @Column({ unique: true })
  id: string; // Unique @username / handle (e.g., "pablo_42")

  @Column()
  name: string; // Display name (e.g., "Pablo")

  @Column()
  contact: string; // Email or contact info

  @Column({ default: '' })
  bio: string; // Personal bio for profile page

  @Column()
  password: string; // Password (kept plain text for now per project rules)

  @Column({ default: '/api/uploads/avatars/default.svg' })
  avatarUrl: string; // Path to uploaded avatar or default SVG

  @Column({ default: false })
  isOnline: boolean; // Online status

  // Gamification fields
  @Column({ default: 0 })
  xp: number; // Total XP earned (2 XP per focused minute)

  @Column({ default: 1 })
  level: number; // Calculated from XP thresholds (Lv1: 0, Lv2: 500, Lv3: 1500)

  @Column({ default: 0 })
  currentStreak: number; // Consecutive days with at least 1 completed focus session

  @Column({ type: 'varchar', nullable: true })
  lastFocusDate: string | null; // YYYY-MM-DD of last completed focus session

  @CreateDateColumn()
  createdAt: Date;
}
