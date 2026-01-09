import { Component, inject, OnInit } from '@angular/core';
import { RouterLink } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [RouterLink, CommonModule],
  templateUrl: './dashboard.html',
  styleUrl: './dashboard.css',
})
export class Dashboard implements OnInit {

  http = inject(HttpClient);

  stats = {
    totalQuiz: 0,
    activeQuiz: 0,
    totalAttempts: 0,
    totalStudents: 0
  };

  ngOnInit() {
    this.http.get<any>(
      'http://localhost:8080/quizapi/dashboard/dashboardstats.jsp'
    ).subscribe(res => {
      if (res.status === 'Success') {
        this.stats = res;
      }
    });
  }
  logout() {
    sessionStorage.clear();
    localStorage.clear();
    window.location.href = '/login';
  }

}
