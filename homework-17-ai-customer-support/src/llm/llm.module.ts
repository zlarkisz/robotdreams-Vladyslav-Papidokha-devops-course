import { Module } from '@nestjs/common';
import { LlmService } from './llm.service';
import { AnthropicService } from './anthropic/anthropic.service';
import { OllamaService } from './ollama/ollama.service';

@Module({
  providers: [LlmService, AnthropicService, OllamaService],
  exports: [LlmService],
})
export class LlmModule {}
