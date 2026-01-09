import { Routes } from '@angular/router';
import { Quiz } from './quiz/quiz';
import { Dashboard } from './dashboard/dashboard';
import { Attempts } from './attempts/attempts';
import { QuestionsComponent } from './questions/questions';
import { Login } from './login/login';

export const routes: Routes = [

  
  { path: '', component: Login },

  
  { path: 'login', component: Login },

  { path: 'dashboard', component: Dashboard },
  { path: 'quiz', component: Quiz },
  { path: 'attempts', component: Attempts },
  { path: 'questions/:id', component: QuestionsComponent },

  
  { path: '**', redirectTo: 'login' }
];
