import { Component, inject, OnInit, ChangeDetectorRef } from '@angular/core';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-result',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './result.html',
})
export class Result implements OnInit {

  private route = inject(ActivatedRoute);
  private router = inject(Router);
  private http = inject(HttpClient);
  private cdr = inject(ChangeDetectorRef);

  data: any = null;
  loading = true;
  attemptid!: number;

  ngOnInit(): void {

    this.route.queryParams.subscribe(params => {
      this.attemptid = Number(params['attemptid'] || params['attemptId']);
      console.log('Result Component - Attempt ID =>', this.attemptid);

      if (!this.attemptid || isNaN(this.attemptid)) {
        alert('Invalid attempt id');
        this.loading = false;
        return;
      }

      this.loadResult();
    });
  }

  loadResult() {
    this.loading = true;

    this.http.get<any>(
      `http://localhost:8080/quizapi/attempt/attemptresult.jsp?attemptid=${this.attemptid}`
    ).subscribe({
      next: res => {
        console.log('RESULT API RESPONSE =>', res);
        this.data = res;
        this.loading = false;
        this.cdr.detectChanges();
      },
      error: () => {
        this.loading = false;
        alert('Result API failed');
      }
    });
  }

  // ✅ ONLY THIS METHOD WILL NAVIGATE
  goToCertificate() {
    this.router.navigate(['/certificate'], {
      queryParams: { attemptid: this.attemptid }
    });
  }
}
