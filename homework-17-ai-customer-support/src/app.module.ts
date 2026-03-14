import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

import { AskModule } from './ask/ask.module';
import { LlmModule } from './llm/llm.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true, // .env доступний у всіх модулях без додаткового імпорту
    }),
    AskModule,
    LlmModule,
  ],
})
export class AppModule {}
