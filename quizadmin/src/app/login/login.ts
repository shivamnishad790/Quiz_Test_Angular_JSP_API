import { CommonModule } from '@angular/common';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Component, inject } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule], 
  templateUrl: './login.html',
  styleUrl: './login.css',
})
export class Login {

  private http = inject(HttpClient);
  private router = inject(Router);

  // form inputs
  username: string = '';
  password: string = '';

  // UI
  loading = false;
  errorMessage = '';

  // API URL
  private apiUrl = 'http://localhost:8080/quizapi/admin/login.jsp';

  // ================= LOGIN FUNCTION =================
  onLogin() {
    this.errorMessage = '';

    if (!this.username || !this.password) {
      this.errorMessage = 'Username and password are required';
      return;
    }

    this.loading = true;

    const body = new URLSearchParams();
    body.set('username', this.username);
    body.set('password', this.password);

    const headers = new HttpHeaders().set(
      'Content-Type',
      'application/x-www-form-urlencoded'
    );

    this.http.post<any>(this.apiUrl, body.toString(), { headers }).subscribe({
      next: (data) => {
        console.log('login response =>', data);
        this.loading = false;

        if (data.status === 'Success') {
          alert('Login Successful');

          // Future use of login session
          // localStorage.setItem('admin', JSON.stringify(data));

          this.router.navigate(['/dashboard']);
        } else {
          this.errorMessage = data.message || 'Invalid username or password';
        }
      },
      error: (err) => {
        console.error('Login Error:', err);
        this.loading = false;
        this.errorMessage = 'API error, console check karo';
      }
    });
  }
}
