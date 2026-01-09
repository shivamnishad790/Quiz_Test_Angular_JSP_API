import { Component, inject, OnInit, ChangeDetectorRef } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';

import html2canvas from 'html2canvas';
import jsPDF from 'jspdf';

@Component({
  selector: 'app-certificate',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './certificate.html',
  styleUrl: './certificate.css',
})
export class Certificate implements OnInit {

  route = inject(ActivatedRoute);
  http = inject(HttpClient);
  cdr = inject(ChangeDetectorRef);

  data: any = null;
  today = '';
  certificateId = '';

  ngOnInit() {
    this.route.queryParams.subscribe(params => {
      const attemptid = params['attemptid'] || params['attemptId'];
      console.log('Certificate Component - Attempt ID =>', attemptid);

      if (!attemptid) {
        console.error('Attempt ID not found');
        return;
      }

      // 📅 Date
      const d = new Date();
      this.today = d.toLocaleDateString('en-IN', {
        day: '2-digit',
        month: 'long',
        year: 'numeric'
      });

      // 🆔 Certificate ID
      this.certificateId = `DCT-${attemptid}-${Date.now().toString().slice(-4)}`;

      // 📡 API CALL
      this.http.get<any>(
        `http://localhost:8080/quizapi/attempt/attemptresult.jsp?attemptid=${attemptid}`
      ).subscribe(res => {
        console.log('Certificate API Response =>', res);
        this.data = res;
        this.cdr.detectChanges(); // 🔥 Force UI Update
      });
    });
  }

  // ⬇ PDF DOWNLOAD
  downloadPDF() {
    const element = document.getElementById('certificate')!;

    html2canvas(element, {
      scale: 3,
      useCORS: true,
      backgroundColor: null
    }).then(canvas => {

      const imgData = canvas.toDataURL('image/png');
      const pdf = new jsPDF('l', 'px', [canvas.width, canvas.height]);

      pdf.addImage(imgData, 'PNG', 0, 0, canvas.width, canvas.height);
      pdf.save(`Certificate-${this.data?.name || 'User'}.pdf`);
    });
  }
}
