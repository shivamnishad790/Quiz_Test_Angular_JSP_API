import { CommonModule } from '@angular/common';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Component, OnInit, inject } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, RouterLink } from '@angular/router';

@Component({
  selector: 'app-questions',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './questions.html',
  styleUrl: './questions.css',
})
export class QuestionsComponent implements OnInit {

  // --------- DI ---------
  private http = inject(HttpClient);
  private route = inject(ActivatedRoute);

  // --------- FORM FIELDS ---------
  quizid: string = '';
  question: string = '';
  ans1: string = '';
  ans2: string = '';
  ans3: string = '';
  ans4: string = '';
  correctans: string = '';

  // --------- LIST (table) ---------
  allquiz: any[] = [];    // tumhare HTML me naam allquiz hai, isliye ye hi rakha

  // --------- EDIT STATE ---------
  isEditMode: boolean = false;
  editId: string | null = null;

  // --------- BASE URL ---------
  private baseUrl = 'http://localhost:8080/quizapi/question';

  ngOnInit(): void {
    // route se quiz id ( /questions/:id )
    this.quizid = this.route.snapshot.paramMap.get('id') ?? '';
    this.loadQuestions();
  }

  // ================== LIST LOAD (questionshowalldata.jsp) ==================
  loadQuestions(): void {
    const apiurl = `${this.baseUrl}/questionshowalldata.jsp?quizid=${this.quizid}`;

    this.http.get<any[]>(apiurl).subscribe({
      next: (data) => {
        console.log('questions list =>', data);
        this.allquiz = data;     // DB se aaye hue sare questions
      },
      error: (err) => {
        console.error('questions list error', err);
        alert('Questions list API error, console check karo');
      }
    });
  }

  // ================== FORM SUBMIT (Add / Update) ==================
  // HTML: (ngSubmit)="saveQuestion()"
  saveQuestion(): void {
    if (this.isEditMode) {
      this.updateQuestion();
    } else {
      this.addQuestion();
    }
  }

  // ================== ADD QUESTION (questionadd.jsp) ==================
  private addQuestion(): void {
    if (!this.isFormValid()) {
      alert('All fields are required');
      return;
    }

    const body = new URLSearchParams();
    body.set('quizid', this.quizid);
    body.set('question', this.question);
    body.set('ans1', this.ans1);
    body.set('ans2', this.ans2);
    body.set('ans3', this.ans3);
    body.set('ans4', this.ans4);
    body.set('correctans', this.correctans);

    const headers = new HttpHeaders().set(
      'Content-Type',
      'application/x-www-form-urlencoded'
    );

    const apiurl = `${this.baseUrl}/questionadd.jsp`;

    this.http.post<any>(apiurl, body.toString(), { headers }).subscribe({
      next: (data) => {
        console.log('add question =>', data);
        if (data.status === 'Success') {
          alert('Question Added');
          this.resetForm();
          this.loadQuestions();  // naya data dubara DB se
        } else {
          alert(data.message || data.Message || 'Add failed');
        }
      },
      error: (err) => {
        console.error('add question error', err);
        alert('Add question API error, console check karo');
      }
    });
  }

  // ================== DELETE QUESTION (questiondelete.jsp) ==================
  deleteQuestion(id: string): void {
    if (!confirm('Are you sure to delete this question?')) return;

    const apiurl = `${this.baseUrl}/questiondelete.jsp?id=${id}`;

    this.http.get<any>(apiurl).subscribe({
      next: (data) => {
        console.log('delete =>', data);
        if (data.status === 'Success') {
          alert('Question Deleted');
          this.loadQuestions();   // fresh list DB se
        } else {
          alert(data.Message || 'Delete failed');
        }
      },
      error: (err) => {
        console.error('delete error', err);
        alert('Delete API error, console check karo');
      }
    });
  }

  // ================== EDIT START (row click) ==================
  editQuestion(item: any): void {
    // Option 1: directly row se data use karo:
    this.isEditMode = true;
    this.editId = String(item.id);

    this.quizid = item.quizid;
    this.question = item.question;
    this.ans1 = item.ans1;
    this.ans2 = item.ans2;
    this.ans3 = item.ans3;
    this.ans4 = item.ans4;
    this.correctans = item.correctans;

    // Option 2: agar hamesha backend se fresh data chahiye to:
    // this.loadSingleQuestion(item.id);
  }

  // (optional) single question API use karna ho:
  loadSingleQuestion(id: string): void {
    const apiurl = `${this.baseUrl}/questionshowsingledata.jsp?id=${id}`;

    this.http.get<any>(apiurl).subscribe({
      next: (data) => {
        console.log('single question =>', data);
        this.isEditMode = true;
        this.editId = String(data.id);

        this.quizid = data.quizid;
        this.question = data.question;
        this.ans1 = data.ans1;
        this.ans2 = data.ans2;
        this.ans3 = data.ans3;
        this.ans4 = data.ans4;
        this.correctans = data.correctans;
      },
      error: (err) => {
        console.error('single question error', err);
      }
    });
  }

  // ================== UPDATE QUESTION (questionupdate.jsp) ==================
  private updateQuestion(): void {
    if (!this.editId) {
      alert('editId missing');
      return;
    }

    if (!this.isFormValid()) {
      alert('All fields are required');
      return;
    }

    const body = new URLSearchParams();
    body.set('id', this.editId);
    body.set('quizid', this.quizid);
    body.set('question', this.question);
    body.set('ans1', this.ans1);
    body.set('ans2', this.ans2);
    body.set('ans3', this.ans3);
    body.set('ans4', this.ans4);
    body.set('correctans', this.correctans);

    const headers = new HttpHeaders().set(
      'Content-Type',
      'application/x-www-form-urlencoded'
    );

    const apiurl = `${this.baseUrl}/questionupdate.jsp`;

    this.http.post<any>(apiurl, body.toString(), { headers }).subscribe({
      next: (data) => {
        console.log('update question =>', data);
        if (data.status === 'Success') {
          alert('Question Updated');
          this.isEditMode = false;
          this.editId = null;
          this.resetForm();
          this.loadQuestions();   // updated data DB se
        } else {
          alert(data.message || data.Message || 'Update failed');
        }
      },
      error: (err) => {
        console.error('update question error', err);
        alert('Update API error, console check karo');
      }
    });
  }

  // ================== HELPERS ==================
  private isFormValid(): boolean {
    return !!(
      this.quizid &&
      this.question &&
      this.ans1 &&
      this.ans2 &&
      this.ans3 &&
      this.ans4 &&
      this.correctans
    );
  }

  resetForm(): void {
    this.question = '';
    this.ans1 = '';
    this.ans2 = '';
    this.ans3 = '';
    this.ans4 = '';
    this.correctans = '';
  }
}
