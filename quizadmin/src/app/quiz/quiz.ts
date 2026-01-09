import { CommonModule } from '@angular/common';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Component, inject, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';

@Component({
  selector: 'app-quiz',
  imports: [RouterLink, FormsModule, CommonModule],
  templateUrl: './quiz.html',
  styleUrl: './quiz.css',
})
export class Quiz implements OnInit {
  http = inject(HttpClient);
  route = inject(Router);

  // ---------- FORM FIELDS ----------
  quizname: string = '';
  quizdesc: string = '';
  quizcode: string = '';
  quiztime: string = '';
  totalquestions: string = '';

  // ---------- LIST ----------
  allquiz: any[] = [];

  // ---------- UPDATE/EDIT STATE ----------
  isEditMode: boolean = false; // false = Add, true = Edit
  editId: string | null = null; // jis quiz ko update kar rahe ho uski id

  ngOnInit() {
    this.showquiz();
  }

  // ================== ADD QUIZ ==================
  addquiz() {
    if (
      this.quizname !== '' &&
      this.quizdesc !== '' &&
      this.quizcode !== '' &&
      this.quiztime !== '' &&
      this.totalquestions !== ''
    ) {
      const urldata = new URLSearchParams();
      urldata.set('quizname', this.quizname);
      urldata.set('quizdesc', this.quizdesc);
      urldata.set('quizcode', this.quizcode);
      urldata.set('totalquestions', this.totalquestions);
      urldata.set('quiztime', this.quiztime);

      const headers = new HttpHeaders().set(
        'Content-Type',
        'application/x-www-form-urlencoded'
      );

      const apiurl = 'http://localhost:8080/quizapi/quiz/quizadd.jsp';

      this.http.post<any>(apiurl, urldata.toString(), { headers }).subscribe({
        next: (data) => {
          console.log('add =>', data);
          alert('Quiz Added');
          this.showquiz();
          this.resetForm();
        },
        error: (err) => {
          console.log('Add Error', err);
          alert('Add API error, console check karo');
        },
      });
    } else {
      alert('All Field Required');
    }
  }

  // ================== SHOW QUIZ LIST ==================
  showquiz() {
    const apiurl = 'http://localhost:8080/quizapi/quiz/quizshowalldata.jsp';

    this.http.get<any>(apiurl).subscribe({
      next: (data) => {
        console.log('show =>', data);
        this.allquiz = data;
      },
      error: (err) => {
        console.log('show api call error', err);
      },
    });
  }

  // ================== DELETE QUIZ ==================
  deletequiz(id: string) {
    const apiurl =
      'http://localhost:8080/quizapi/quiz/quizdelete.jsp?id=' + id;

    this.http.get<any>(apiurl).subscribe({
      next: (data) => {
        console.log('delete response =>', data);
        if (data.status === 'Success') {
          alert('Quiz Deleted');
          this.showquiz();
        } else {
          alert(data.Message || 'Delete failed');
        }
      },
      error: (err) => {
        console.error('delete api error', err);
        alert('Delete API error, console check karo');
      },
    });
  }

  // ================== OPEN QUESTIONS PAGE ==================
  addquestion(id: string) {
    this.route.navigate(['/questions', id]);
  }

  // ================== EDIT MODE + FORM FILL ==================
  editQuiz(item: any) {
    this.isEditMode = true;
    this.editId = String(item.id); // id store

    // form me purana data fill
    this.quizname = item.quizname;
    this.quizdesc = item.quizdesc;
    this.quizcode = item.quizcode;
    this.totalquestions = item.totalquestions || item.tatalquestions;
    this.quiztime = item.quiztime;
  }

  // ================== UPDATE QUIZ ==================
  updatequiz() {
    if (
      this.editId &&
      this.quizname !== '' &&
      this.quizdesc !== '' &&
      this.quizcode !== '' &&
      this.quiztime !== '' &&
      this.totalquestions !== ''
    ) {
      const urldata = new URLSearchParams();
      urldata.set('id', this.editId); // ⭐ backend ko id yahi milegi
      urldata.set('quizname', this.quizname);
      urldata.set('quizdesc', this.quizdesc);
      urldata.set('quizcode', this.quizcode);
      urldata.set('totalquestions', this.totalquestions);
      urldata.set('quiztime', this.quiztime);

      const headers = new HttpHeaders().set(
        'Content-Type',
        'application/x-www-form-urlencoded'
      );

      const apiurl = 'http://localhost:8080/quizapi/quiz/quizupdate.jsp';

      this.http.post<any>(apiurl, urldata.toString(), { headers }).subscribe({
        next: (data) => {
          console.log('update =>', data);
          alert('Quiz Updated');
          this.showquiz();
          this.isEditMode = false;
          this.editId = null;
          this.resetForm();
        },
        error: (err) => {
          console.log('Update Error', err);
          alert('Update API error, console check karo');
        },
      });
    } else {
      alert('All Field Required (and editId bhi)');
    }
  }

  // ================== FORM RESET ==================
  resetForm() {
    this.quizname = '';
    this.quizdesc = '';
    this.quizcode = '';
    this.quiztime = '';
    this.totalquestions = '';
  }
  logout() {
  sessionStorage.clear();
  localStorage.clear();
  this.route.navigate(['/login']);
}

}
