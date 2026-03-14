import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Anthropic from '@anthropic-ai/sdk';

@Injectable()
export class AnthropicService {
  private readonly client: Anthropic;
  private readonly logger = new Logger(AnthropicService.name);

  constructor(private config: ConfigService) {
    this.client = new Anthropic({
      apiKey: this.config.get<string>('ANTHROPIC_API_KEY'),
    });
  }

  async ask(question: string): Promise<string> {
    this.logger.log(`Sending question to Anthropic: "${question}"`);

    const message = await this.client.messages.create({
      model: 'claude-haiku-4-5-20251001',
      max_tokens: 1024,
      system:
        'You are a helpful customer support assistant. Answer questions clearly and concisely.',
      messages: [{ role: 'user', content: question }],
    });

    const response = message.content[0];
    if (response.type !== 'text') {
      throw new Error('Unexpected response type from Anthropic');
    }

    this.logger.log(`Received response from Anthropic`);

    return response.text;
  }
}
