import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  internalId: number;

  @Column({ unique: true })
  id: string; // The @ handle (e.g., "pablo_42")

  @Column()
  name: string; // Display name (e.g., "Pablo")

  @Column()
  contact: string; // Contact info (e.g., email or phone)

  @Column()
  password: string; // Plain text password

  @CreateDateColumn()
  createdAt: Date;
}
