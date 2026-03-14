import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AnthropicService } from './anthropic/anthropic.service';
import { OllamaService } from './ollama/ollama.service';

@Injectable()
export class LlmService {
  constructor(
    private config: ConfigService,
    private anthropic: AnthropicService,
    private ollama: OllamaService,
  ) {}

  async ask(question: string): Promise<string> {
    const provider = this.config.get<string>('LLM_PROVIDER') ?? 'anthropic';

    if (provider === 'ollama') {
      return this.ollama.ask(question);
    }

    return this.anthropic.ask(question);
  }
}
