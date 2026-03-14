import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios from 'axios';

interface OllamaResponse {
  response: string;
  model: string;
  done: boolean;
}

@Injectable()
export class OllamaService {
  private readonly baseUrl: string;
  private readonly model: string;
  private readonly logger = new Logger(OllamaService.name);

  constructor(private config: ConfigService) {
    this.baseUrl =
      this.config.get<string>('OLLAMA_BASE_URL') ?? 'http://localhost:11434';
    this.model = this.config.get<string>('OLLAMA_MODEL') ?? 'phi3';
  }

  async ask(question: string): Promise<string> {
    this.logger.log(
      `Sending question to Ollama (${this.model}): "${question}"`,
    );

    const response = await axios.post<OllamaResponse>(
      `${this.baseUrl}/api/generate`,
      {
        model: this.model,
        prompt: `You are a helpful customer support assistant. Answer clearly and concisely.\n\nQuestion: ${question}`,
        stream: false,
      },
      { timeout: 60000 },
    );

    this.logger.log(`Received response from Ollama`);

    return response.data.response;
  }
}
