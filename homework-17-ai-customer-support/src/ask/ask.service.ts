import { Injectable } from '@nestjs/common';
import { LlmService } from '../llm/llm.service';

@Injectable()
export class AskService {
  constructor(private readonly llm: LlmService) {}

  async ask(question: string): Promise<string> {
    return this.llm.ask(question);
  }
}
