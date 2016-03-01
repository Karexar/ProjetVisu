noFill();
beginShape();
for(int i = 0; i < 20; i++) {
  int y = i % 2;
  vertex(i * 10, 50 + y * 10);
}
endShape();