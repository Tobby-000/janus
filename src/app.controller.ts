import { Controller, All, Req, Res, Get, Redirect } from '@nestjs/common';
import { Request, Response } from "express";
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) { }

  @Get("/interaction/:uid")
  async interaction(@Req() req: Request, @Res() res: Response): Promise<object | void> {
    return this.appService.interaction(req, res);
  }
  @Get("/interaction/:uid/callback")
  async interactionLogin(@Req() req: Request, @Res() res: Response): Promise<void> {
    return this.appService.interactionCallback(req, res);
  }

  @Get("/userinfo")
  @Redirect("", 303)
  async userinfo(): Promise<object> {
    return {
      url: this.appService.getSiteUrl() + "/yggc/userinfo",
    };
  }

  /* @Get('/device')
  async userCodeVerification(@Req() req: Request, @Res() res: Response, @Query('xsrf') query: string): Promise<void | object> {
    if(query != undefined) {
      return this.appService.callback(req, res);
    } else {
      const url = this.appService.getSiteUrl() + "/yggc/device";
      res.redirect(HttpStatus.SEE_OTHER, url);
    }
  } */

  @All("/*")
  getHello(@Req() req: Request, @Res() res: Response): Promise<void> {
    return this.appService.callback(req, res);
  }
}
