package com.ruoyi.web.controller.health;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/health")
public class HealthCheckController {

    @GetMapping("/check")
    public ResponseEntity<?> healthCheck(@RequestParam("DETECT") String detect) {
        if ("DETECT".equalsIgnoreCase(detect)) {
            return ResponseEntity.ok("SUCCEED");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("FAILED");
        }
    }
}
