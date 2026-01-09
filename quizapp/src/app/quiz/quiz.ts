import { CommonModule } from '@angular/common';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import {
  Component,
  inject,
  OnInit,
  ChangeDetectorRef,
  NgZone
} from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-quiz',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './quiz.html',
  styleUrl: './quiz.css',
})
export class Quiz implements OnInit {

  // =============================
  // DEPENDENCIES
  // =============================
  http = inject(HttpClient);
  route = inject(ActivatedRoute);
  router = inject(Router);
  cdr = inject(ChangeDetectorRef);
  zone = inject(NgZone);

  // =============================
  // BASIC DATA
  // =============================
  quizcode!: string;
  attemptid!: number;

  quizdata: any = null;
  questiondata: any[] = [];

  loading = true;

  // =============================
  // TIMER
  // =============================
  currenttime: string = '00:00';
  currentseconds: number = 0;
  timerInterval: any;

  // =============================
  // QUESTIONS
  // =============================
  currentQuestion = 0;
  availablequestions = 0;
  isLastQuestion = false;
  selectedAnswers: string[] = [];

  // =============================
  // INIT
  // =============================
  ngOnInit() {

    this.route.queryParams.subscribe(params => {

      this.quizcode = params['quizcode'];
      this.attemptid = Number(params['attemptid'] || params['attemptId']);

      console.log('quizcode =', this.quizcode);
      console.log('attemptid =', this.attemptid);

      if (!this.quizcode || !this.attemptid) {
        alert('Quizcode or Attempt ID missing');
        this.loading = false;
        return;
      }

      this.loadQuiz();
      
    });
    // 🔥 end queryParams subscribe


  }

  // =============================
  // LOAD QUIZ
  // =============================
  loadQuiz() {

    this.http.get<any>(
      `http://localhost:8080/quizapi/attempt/quizshowsingledata.jsp?quizcode=${this.quizcode}`
    ).subscribe({
      next: res => {

        console.log('QUIZ API =>', res);

        if (res.status?.toLowerCase() === 'success' && res.data) {

          this.quizdata = res.data;

          // JSP se time minutes me aata hai
          const totalMinutes = Number(this.quizdata.quiztime) || 0;
          this.currentseconds = totalMinutes * 60;

          if (this.currentseconds > 0) {
            this.startTimer(); // 🔥 timer start
          }

          this.loadQuestions(Number(this.quizdata.id));

        } else {
          alert('Quiz not found');
          this.loading = false;
        }
      },
      error: () => {
        alert('Quiz API failed');
        this.loading = false;
      }
    });
  }

  // =============================
  // LOAD QUESTIONS
  // =============================
  loadQuestions(quizid: number) {

    this.http.get<any>(
      `http://localhost:8080/quizapi/attempt/allquestionquizid.jsp?quizid=${quizid}`
    ).subscribe({
      next: res => {

        console.log('QUESTION API =>', res);

        if (res.status === 'Success' && Array.isArray(res.data)) {

          this.questiondata = res.data;
          this.availablequestions = this.questiondata.length;

          this.loading = false;
          this.cdr.detectChanges();

        } else {
          alert('No questions found');
          this.loading = false;
        }
      },
      error: () => {
        alert('Question API failed');
        this.loading = false;
      }
    });
  }

  // =============================
  // TIMER (🔥 FIXED – NO CLICK LAG)
  // =============================
  startTimer() {

    this.zone.runOutsideAngular(() => {

      this.timerInterval = setInterval(() => {

        if (this.currentseconds <= 0) {
          clearInterval(this.timerInterval);

          this.zone.run(() => {
            this.submitQuiz(); // ⏰ auto submit
          });

          return;
        }

        this.currentseconds--;

        const minutes = Math.floor(this.currentseconds / 60);
        const seconds = this.currentseconds % 60;

        const time =
          this.getTwoDigit(minutes) + ':' + this.getTwoDigit(seconds);

        // 🔥 force UI update
        this.zone.run(() => {
          this.currenttime = time;
          this.cdr.detectChanges();
        });

      }, 1000);

    });
  }

  getTwoDigit(num: number) {
    return num < 10 ? '0' + num : num.toString();
  }

  // =============================
  // NAVIGATION
  // =============================
  nextQuestion() {
    if (this.currentQuestion < this.availablequestions - 1) {
      this.currentQuestion++;
    }
    this.isLastQuestion =
      this.currentQuestion === this.availablequestions - 1;
  }

  prevQuestion() {
    if (this.currentQuestion > 0) {
      this.currentQuestion--;
    }
    this.isLastQuestion = false;
  }

  // =============================
  // SUBMIT QUIZ
  // =============================
  submitQuiz() {

    if (!confirm('Submit Quiz?')) return;

    clearInterval(this.timerInterval);

    const answers = this.questiondata.map((q, i) => ({
      questionid: q.id,
      userans: this.selectedAnswers[i] || ''
    }));

    const body = new URLSearchParams();
    body.set('attemptid', this.attemptid.toString());
    body.set('answers', JSON.stringify(answers));

    const headers = new HttpHeaders({
      'Content-Type': 'application/x-www-form-urlencoded'
    });

    this.http.post<any>(
      'http://localhost:8080/quizapi/attempt/attemptsubmit.jsp',
      body.toString(),
      { headers }
    ).subscribe(res => {

      console.log('SUBMIT RESPONSE =>', res);

      if (res.status === 'Success') {
        this.router.navigate(['/result'], {
          queryParams: { attemptid: this.attemptid }
        });
      } else {
        alert(res.message || 'Submit failed');
      }
    });
  }
}
