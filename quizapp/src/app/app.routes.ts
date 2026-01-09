import { Routes } from '@angular/router';
import { Home } from './home/home';
import { Quizform } from './quizform/quizform';
import { Quiz } from './quiz/quiz';
import { Result } from './result/result';
import { Certificate } from './certificate/certificate';

export const routes: Routes = [
  { path: '', component: Home },
  { path: 'start', component: Quizform },
  { path: 'quiz', component: Quiz },
  { path: 'result', component: Result },
  { path: 'certificate', component: Certificate },
];

