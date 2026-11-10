import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);

  app.setGlobalPrefix('api');

  // Enable CORS with credentials so the frontend can send/receive HttpOnly session cookies
  app.enableCors({
    origin: true,
    credentials: true,
  });

  // Serve uploaded files (e.g. avatars) statically at /api/uploads/...
  app.useStaticAssets(join(process.cwd(), 'uploads'), {
    prefix: '/api/uploads/',
  });

  const port = process.env.PORT || 3000;
  await app.listen(port, '0.0.0.0');
  console.log(`Superfocus API running on http://0.0.0.0:${port}/api`);
}

bootstrap();
