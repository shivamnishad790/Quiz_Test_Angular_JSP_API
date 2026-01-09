import { CommonModule } from '@angular/common';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Component, inject } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-quizform',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './quizform.html',
  styleUrl: './quizform.css',
})
export class Quizform {

  private http = inject(HttpClient);
  private router = inject(Router);

  name = '';
  mobile = '';
  email = '';
  collegename = '';
  quizcode = '';

  loading = false;
  error = '';

  apiUrl = 'http://localhost:8080/quizapi/attempt/attemptadd.jsp';

  startQuiz() {
    this.error = '';

    if (!this.name || !this.mobile || !this.email || !this.collegename || !this.quizcode) {
      this.error = 'All fields are required';
      return;
    }

    this.loading = true;

    const body = new URLSearchParams();
    body.set('name', this.name);
    body.set('mobile', this.mobile);
    body.set('email', this.email);
    body.set('collegename', this.collegename);
    body.set('quizcode', this.quizcode);

    const headers = new HttpHeaders({
      'Content-Type': 'application/x-www-form-urlencoded'
    });

    // STEP 1 → Add Attempt
    this.http.post<any>(this.apiUrl, body.toString(), { headers }).subscribe({
      next: (res) => {

        if (res.status?.toLowerCase() === 'success') {
          const attemptId = res.id;

          // STEP 2 → Load Quiz
          this.http.get<any>(
            'http://localhost:8080/quizapi/attempt/quizshowsingledata.jsp?quizcode=' + this.quizcode
          ).subscribe({
            next: (quizRes) => {
              this.loading = false;

              if (quizRes.status?.toLowerCase() === 'success') {
                localStorage.setItem('quizdata', JSON.stringify(quizRes));

                // STEP 3 → Navigate ONCE
                this.router.navigate(['/quiz'], {
                  queryParams: {
                    quizcode: this.quizcode,
                    attemptid: attemptId
                  }
                });
              } else {
                this.error = 'Invalid Quiz Code';
              }
            },
            error: () => {
              this.loading = false;
              this.error = 'Quiz loading failed';
            }
          });

        } else {
          this.loading = false;
          this.error = res.message || 'Could not start quiz';
        }
      },
      error: () => {
        this.loading = false;
        this.error = 'Server error, try again';
      }
    });
  }
}
