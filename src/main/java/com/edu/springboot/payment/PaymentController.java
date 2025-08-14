package com.edu.springboot.payment;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PaymentController {

	@GetMapping("/checkout")
	public String checkout() {
		return "payment/checkout";
	}
	
	@GetMapping("/success")
	public String success() {
		return "payment/success";
	}
	
	@GetMapping("/fail")
	public String fail() {
		return "payment/fail";
	}

}
