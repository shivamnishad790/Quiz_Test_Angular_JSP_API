import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Quizform } from './quizform';

describe('Quizform', () => {
  let component: Quizform;
  let fixture: ComponentFixture<Quizform>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [Quizform]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Quizform);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
