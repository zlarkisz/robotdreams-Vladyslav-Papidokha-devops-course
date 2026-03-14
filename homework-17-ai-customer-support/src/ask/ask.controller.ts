import { Controller, Post, Body } from '@nestjs/common';
import { AskService } from './ask.service';
import { AskDto } from './ask.dto';

@Controller('ask')
export class AskController {
  constructor(private readonly askService: AskService) {}

  @Post()
  async ask(@Body() dto: AskDto) {
    const answer = await this.askService.ask(dto.question);

    return { answer };
  }
}
