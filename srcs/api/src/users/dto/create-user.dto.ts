export class CreateUserDto {
  id: string; // The @username handle
  name: string;
  contact: string;
  password: string;
  bio?: string;
}
