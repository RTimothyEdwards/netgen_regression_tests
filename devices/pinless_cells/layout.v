// Two cells with no pins (e.g., decap or fill cells without power pins),
// which are merged as parallel devices.
module top (input a, output y);
  buf_cell b0 (.A(a), .Y(y));
  fill f0 ();
  fill f1 ();
endmodule
