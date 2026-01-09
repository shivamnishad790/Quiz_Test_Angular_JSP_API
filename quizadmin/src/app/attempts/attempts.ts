import { Component, OnInit, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { RouterLink } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-attempts',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule],
  templateUrl: './attempts.html',
  styleUrl: './attempts.css',
})
export class Attempts implements OnInit {

  http = inject(HttpClient);

  attempts: any[] = [];
  filteredAttempts: any[] = [];
  searchText: string = '';

  ngOnInit() {
    this.loadAttempts();
  }

  loadAttempts() {
    this.http.get<any>(
      'http://localhost:8080/quizapi/attempt/attemptshowall.jsp'
    ).subscribe(res => {
      if (res.status === 'Success') {
        this.attempts = res.data;
        this.filteredAttempts = res.data;
      }
    });
  }

  searchQuiz() {
    const text = this.searchText.toLowerCase();

    this.filteredAttempts = this.attempts.filter(a =>
      a.quizcode.toLowerCase().includes(text)
    );
  }

  getMarks(a: any): string {
    return `${a.correct}/${a.totalquestions}`;
  }
logout() {
    sessionStorage.clear();
    localStorage.clear();
    window.location.href = '/login';
  }
}
