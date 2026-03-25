<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>EasyRide Dashboard</title>
    <link rel="icon" href="images/easyride-icon.png" type="image/png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Inter', 'Segoe UI', sans-serif;
    }

    body {
        background: linear-gradient(135deg, #f8faff 0%, #e6f3ff 100%);
        min-height: 100vh;
        line-height: 1.6;
    }

    .navbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 25px 60px;
        background: rgba(255, 250, 250, 0.95);
        backdrop-filter: blur(10px);
        border-bottom: 1px solid rgba(0, 123, 255, 0.1);
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        z-index: 1000;
        width: 100%;
        transition: all 0.3s ease;
    }

    .navbar.scrolled {
        background: rgba(255, 250, 250, 0.98);
        backdrop-filter: blur(15px);
        box-shadow: 0 2px 20px rgba(0, 123, 255, 0.1);
    }

    html {
        scroll-behavior: smooth;
    }

    #features, #services, #coverage, #contact {
        scroll-margin-top: 100px;
    }

    .logo {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .logo img {
        height: 36px;
    }

    .logo span {
        font-size: 1.4em;
        color: #007bff;
        font-weight: 600;
        letter-spacing: -0.02em;
    }

    /* Hamburger Menu Styles */
    .hamburger {
        display: none;
        flex-direction: column;
        cursor: pointer;
        padding: 8px;
        background: none;
        border: none;
        z-index: 1001;
    }

    .hamburger span {
        width: 25px;
        height: 3px;
        background: #007bff;
        margin: 3px 0;
        transition: all 0.3s ease;
        border-radius: 2px;
    }

    .hamburger.active span:nth-child(1) {
        transform: rotate(45deg) translate(5px, 5px);
    }

    .hamburger.active span:nth-child(2) {
        opacity: 0;
    }

    .hamburger.active span:nth-child(3) {
        transform: rotate(-45deg) translate(7px, -6px);
    }

    /* Navigation Styles */
    .nav-container {
        display: flex;
        align-items: center;
        gap: 40px;
    }

    nav ul {
        list-style: none;
        display: flex;
        gap: 40px;
    }

    nav ul li a {
        text-decoration: none;
        color: #007bff;
        font-weight: 500;
        font-size: 0.95em;
        transition: color 0.3s ease;
        position: relative;
    }

    nav ul li a:hover {
        color: #0056b3;
    }

    nav ul li a::after {
        content: '';
        position: absolute;
        bottom: -8px;
        left: 0;
        width: 0;
        height: 2px;
        background: #007bff;
        border-radius: 1px;
        transition: width 0.3s ease;
    }

    nav ul li a:hover::after {
        width: 100%;
    }

    nav ul li a.active::after {
        width: 100%;
    }

    .get-app .btn-app {
        background: #007bff;
        color: #fffafa;
        padding: 12px 24px;
        border-radius: 50px;
        text-decoration: none;
        font-weight: 600;
        font-size: 0.9em;
        transition: all 0.3s ease;
        box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
    }

    .get-app .btn-app:hover {
        background: #0056b3;
        transform: translateY(-1px);
        box-shadow: 0 6px 16px rgba(0, 123, 255, 0.4);
    }

    .hero {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 80px 60px 80px 60px;
        gap: 60px;
        max-width: 1400px;
        margin: 0 auto;
    }

    .hero-text {
        flex: 1;
        max-width: 550px;
    }

    .hero-text h1 {
        font-size: 3.2em;
        color: #007bff;
        font-weight: 700;
        line-height: 1.1;
        margin-bottom: 24px;
        letter-spacing: -0.02em;
    }

    .hero-text p {
        color: #007bff;
        font-size: 1.2em;
        margin-bottom: 40px;
        opacity: 0.8;
        font-weight: 400;
    }

    .store-buttons {
        display: flex;
        gap: 20px;
        align-items: center;
        flex-wrap: wrap;
    }

    .store-button {
        display: inline-block;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        border-radius: 16px;
        overflow: hidden;
        position: relative;
        background: #000;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        border: 2px solid transparent;
    }

    .store-button::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0.05) 100%);
        opacity: 0;
        transition: opacity 0.3s ease;
        pointer-events: none;
    }

    .store-button:hover {
        transform: translateY(-3px) scale(1.02);
        box-shadow: 0 12px 35px rgba(0, 0, 0, 0.25);
        border-color: rgba(0, 123, 255, 0.3);
    }

    .store-button:hover::before {
        opacity: 1;
    }

    .store-button:active {
        transform: translateY(-1px) scale(1.01);
        transition: transform 0.1s ease;
    }

    .store-button img {
        height: 60px;
        width: auto;
        display: block;
        filter: brightness(1.05) contrast(1.1);
        transition: filter 0.3s ease;
    }

    .store-button:hover img {
        filter: brightness(1.1) contrast(1.15);
    }

    .custom-store-buttons {
        display: flex;
        gap: 16px;
        align-items: center;
        flex-wrap: wrap;
        margin-top: 20px;
    }

    .custom-store-button {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 14px 20px;
        background: linear-gradient(135deg, #000 0%, #333 100%);
        color: white;
        text-decoration: none;
        border-radius: 12px;
        font-weight: 600;
        font-size: 0.9em;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
        border: 1px solid rgba(255, 255, 255, 0.1);
        position: relative;
        overflow: hidden;
        min-width: 160px;
    }

    .custom-store-button::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
        transition: left 0.5s ease;
    }

    .custom-store-button:hover::before {
        left: 100%;
    }

    .custom-store-button:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
        background: linear-gradient(135deg, #111 0%, #444 100%);
    }

    .store-icon {
        width: 24px;
        height: 24px;
        fill: currentColor;
    }

    .button-text {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        line-height: 1.2;
    }

    .button-text .small {
        font-size: 0.75em;
        opacity: 0.8;
        font-weight: 400;
    }

    .button-text .large {
        font-size: 1em;
        font-weight: 600;
    }

    .hero-image {
        flex: 1;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        position: relative;
        gap: 15px;
    }

    .hero-image::before {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 300px;
        height: 300px;
        background: radial-gradient(circle, rgba(0, 123, 255, 0.1) 0%, transparent 70%);
        border-radius: 50%;
        transform: translate(-50%, -50%);
        z-index: 0;
    }

    .hero-image img {
        max-width: 400px;
        height: auto;
        position: relative;
        z-index: 1;
        filter: drop-shadow(0 20px 40px rgba(0, 123, 255, 0.2));
    }

    .book-now {
        display: inline-block;
        padding: 12px 24px;
        background: #007bff;
        color: #fffafa;
        text-decoration: none;
        font-weight: 600;
        font-size: 0.9em;
        border-radius: 50px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
        z-index: 2;
        pointer-events: auto;
    }

    .book-now:hover {
        background: #0056b3;
        transform: translateY(-1px);
        box-shadow: 0 6px 16px rgba(0, 123, 255, 0.4);
    }

    .features, .services, .coverage, .contact {
        padding: 100px 60px;
        background: rgba(255, 255, 255, 0.7);
        backdrop-filter: blur(20px);
        border-top: 1px solid rgba(0, 123, 255, 0.1);
    }

    .features-container, .services-container, .coverage-container, .contact-container {
        max-width: 1400px;
        margin: 0 auto;
    }

    .features-header, .services-header, .coverage-header, .contact-header {
        text-align: center;
        margin-bottom: 80px;
    }

    .features-header h2, .services-header h2, .coverage-header h2, .contact-header h2 {
        font-size: 2.8em;
        color: #007bff;
        font-weight: 700;
        margin-bottom: 20px;
        letter-spacing: -0.02em;
    }

    .features-header p, .services-header p, .coverage-header p, .contact-header p {
        font-size: 1.2em;
        color: #007bff;
        opacity: 0.8;
        max-width: 600px;
        margin: 0 auto;
        line-height: 1.6;
    }

    .features-grid, .services-grid, .coverage-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
        gap: 50px;
        align-items: start;
    }

    .feature-card, .service-card, .coverage-card {
        background: rgba(255, 255, 255, 0.9);
        border-radius: 24px;
        padding: 50px 40px;
        text-align: center;
        box-shadow: 0 20px 40px rgba(0, 123, 255, 0.1);
        border: 1px solid rgba(0, 123, 255, 0.1);
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        position: relative;
        overflow: hidden;
    }

    .feature-card::before, .service-card::before, .coverage-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(135deg, rgba(0, 123, 255, 0.02) 0%, rgba(0, 123, 255, 0.08) 100%);
        opacity: 0;
        transition: opacity 0.4s ease;
    }

    .feature-card:hover, .service-card:hover, .coverage-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 30px 60px rgba(0, 123, 255, 0.2);
        border-color: rgba(0, 123, 255, 0.3);
    }

    .feature-card:hover::before, .service-card:hover::before, .coverage-card:hover::before {
        opacity: 1;
    }

    .feature-icon, .service-icon, .coverage-icon {
        width: 80px;
        height: 80px;
        margin: 0 auto 30px;
        background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
        border-radius: 20px;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 10px 30px rgba(0, 123, 255, 0.3);
        transition: all 0.4s ease;
        position: relative;
        z-index: 1;
    }

    .feature-card:hover .feature-icon, .service-card:hover .service-icon, .coverage-card:hover .coverage-icon {
        transform: scale(1.1) rotate(5deg);
        box-shadow: 0 15px 40px rgba(0, 123, 255, 0.4);
    }

    .feature-icon svg, .service-icon svg, .coverage-icon svg {
        width: 40px;
        height: 40px;
        fill: white;
    }

    .feature-content, .service-content, .coverage-content {
        position: relative;
        z-index: 1;
    }

    .feature-content h3, .service-content h3, .coverage-content h3 {
        font-size: 1.8em;
        color: #007bff;
        font-weight: 700;
        margin-bottom: 20px;
        letter-spacing: -0.01em;
    }

    .feature-content p, .service-content p, .coverage-content p {
        color: #007bff;
        opacity: 0.8;
        font-size: 1.1em;
        line-height: 1.7;
        margin-bottom: 25px;
    }

    .feature-highlights, .service-highlights {
        display: flex;
        flex-direction: column;
        gap: 12px;
        margin-top: 30px;
    }

    .feature-highlight, .service-highlight {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px 20px;
        background: rgba(0, 123, 255, 0.08);
        border-radius: 12px;
        border: 1px solid rgba(0, 123, 255, 0.15);
        transition: all 0.3s ease;
    }

    .feature-highlight:hover, .service-highlight:hover {
        background: rgba(0, 123, 255, 0.12);
        border-color: rgba(0, 123, 255, 0.25);
    }

    .feature-highlight svg, .service-highlight svg {
        width: 18px;
        height: 18px;
        fill: #007bff;
        flex-shrink: 0;
    }

    .feature-highlight span, .service-highlight span {
        color: #007bff;
        font-weight: 500;
        font-size: 0.95em;
    }

    .contact-form {
        max-width: 600px;
        margin: 0 auto;
        background: rgba(255, 255, 255, 0.9);
        padding: 40px;
        border-radius: 24px;
        box-shadow: 0 20px 40px rgba(0, 123, 255, 0.1);
        border: 1px solid rgba(0, 123, 255, 0.1);
    }

    .contact-form h3 {
        font-size: 1.8em;
        color: #007bff;
        margin-bottom: 20px;
        text-align: center;
    }

    .contact-form .form-group {
        margin-bottom: 20px;
    }

    .contact-form label {
        display: block;
        color: #007bff;
        font-weight: 500;
        margin-bottom: 8px;
        font-size: 0.95em;
    }

    .contact-form input, .contact-form textarea {
        width: 100%;
        padding: 12px;
        border: 1px solid rgba(0, 123, 255, 0.2);
        border-radius: 8px;
        font-size: 0.95em;
        color: #007bff;
        background: rgba(255, 255, 255, 0.8);
        transition: border-color 0.3s ease;
    }

    .contact-form input:focus, .contact-form textarea:focus {
        border-color: #007bff;
        outline: none;
    }

    .contact-form textarea {
        resize: vertical;
        min-height: 120px;
    }

    .contact-form button {
        display: block;
        width: 100%;
        padding: 12px;
        background: #007bff;
        color: #fffafa;
        border: none;
        border-radius: 50px;
        font-weight: 600;
        font-size: 0.95em;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
    }

    .contact-form button:hover {
        background: #0056b3;
        transform: translateY(-1px);
        box-shadow: 0 6px 16px rgba(0, 123, 255, 0.4);
    }

    .contact-info {
        margin-top: 40px;
        text-align: center;
    }

    .contact-info p {
        color: #007bff;
        font-size: 1.1em;
        margin-bottom: 12px;
        opacity: 0.8;
    }

    .contact-info a {
        color: #007bff;
        text-decoration: none;
        font-weight: 500;
        transition: color 0.3s ease;
    }

    .contact-info a:hover {
        color: #0056b3;
    }

    /* Mobile Navigation Overlay */
    .mobile-nav-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100vh;
        background: rgba(0, 0, 0, 0.5);
        z-index: 999;
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    .mobile-nav-overlay.active {
        opacity: 1;
    }

    /* Responsive Design */
    @media (max-width: 1024px) {
        .navbar {
            padding: 20px 40px;
        }

        .hero {
            padding: 120px 40px 60px 40px;
            gap: 40px;
        }

        .hero-text h1 {
            font-size: 2.8em;
        }

        nav ul {
            gap: 30px;
        }

        .hero-image img {
            max-width: 350px;
        }

        .hero-image {
            gap: 18px;
        }
    }

    @media (max-width: 768px) {
        .hamburger {
            display: flex;
            position: fixed;
            top: 20px;
            right: 30px;
            z-index: 1002;
        }

        .navbar {
            padding: 18px 30px;
        }

        .nav-container {
            position: fixed;
            top: 0;
            right: -100%;
            width: 300px;
            height: 100vh;
            background: rgba(255, 250, 250, 0.98);
            backdrop-filter: blur(15px);
            flex-direction: column;
            justify-content: flex-start;
            align-items: stretch;
            padding: 80px 30px 30px;
            transition: right 0.3s ease;
            border-left: 1px solid rgba(0, 123, 255, 0.1);
            box-shadow: -5px 0 20px rgba(0, 123, 255, 0.1);
            z-index: 1000;
        }

        .nav-container.active {
            right: 0;
        }

        nav {
            width: 100%;
            margin-bottom: 30px;
        }

        nav ul {
            flex-direction: column;
            gap: 0;
            width: 100%;
        }

        nav ul li {
            width: 100%;
        }

        nav ul li a {
            display: block;
            padding: 15px 20px;
            font-size: 1.1em;
            border-radius: 12px;
            margin-bottom: 8px;
            background: rgba(0, 123, 255, 0.05);
            border: 1px solid rgba(0, 123, 255, 0.1);
            transition: all 0.3s ease;
        }

        nav ul li a:hover,
        nav ul li a.active {
            background: rgba(0, 123, 255, 0.1);
            border-color: rgba(0, 123, 255, 0.2);
        }

        nav ul li a::after {
            display: none; /* Disable hover line in mobile menu */
        }

        .get-app {
            width: 100%;
        }

        .get-app .btn-app {
            display: block;
            text-align: center;
            width: 100%;
            padding: 15px 24px;
            font-size: 1em;
        }

        .mobile-nav-overlay {
            display: block;
        }

        .hero {
            flex-direction: column;
            text-align: center;
            padding: 110px 30px 50px 30px;
        }

        .hero-text {
            max-width: none;
        }

        .hero-text h1 {
            font-size: 2.4em;
        }

        .hero-text p {
            font-size: 1.1em;
        }

        .store-buttons {
            justify-content: center;
        }

        .custom-store-buttons {
            justify-content: center;
        }

        .hero-image img {
            max-width: 300px;
        }

        .hero-image {
            gap: 16px;
        }

        .book-now {
            padding: 10px 20px;
            font-size: 0.85em;
        }

        .features, .services, .coverage, .contact {
            padding: 80px 40px;
        }

        .features-grid, .services-grid, .coverage-grid {
            grid-template-columns: 1fr;
            gap: 40px;
        }

        .feature-card, .service-card, .coverage-card {
            padding: 40px 30px;
        }

        .features-header h2, .services-header h2, .coverage-header h2, .contact-header h2 {
            font-size: 2.4em;
        }
    }

    @media (max-width: 480px) {
        .navbar {
            padding: 15px 20px;
        }

        .logo span {
            font-size: 1.2em;
        }

        .logo img {
            height: 32px;
        }

        .nav-container {
            width: 280px;
            padding: 70px 25px 25px;
        }

        .hamburger {
            top: 15px;
            right: 20px;
        }

        .hero-text h1 {
            font-size: 2em;
        }

        .store-buttons {
            flex-direction: column;
            gap: 12px;
            align-items: center;
        }

        .store-button img {
            height: 52px;
        }

        .custom-store-button {
            min-width: 140px;
            padding: 12px 16px;
        }

        .hero-image img {
            max-width: 250px;
        }

        .hero-image {
            gap: 14px;
        }

        .book-now {
            padding: 8px 16px;
            font-size: 0.8em;
        }

        .features, .services, .coverage, .contact {
            padding: 60px 30px;
        }

        .features-header h2, .services-header h2, .coverage-header h2, .contact-header h2 {
            font-size: 2em;
        }

        .features-header p, .services-header p, .coverage-header p, .contact-header p {
            font-size: 1em;
        }

        .feature-card, .service-card, .coverage-card {
            padding: 35px 25px;
        }

        .feature-content h3, .service-content h3, .coverage-content h3 {
            font-size: 1.5em;
        }

        .feature-content p, .service-content p, .coverage-content p {
            font-size: 1em;
        }

        .contact-form {
            padding: 30px;
        }
    }

    .driver-signup {
        padding: 80px 60px;
        max-width: 1400px;
        margin: 0 auto;
        scroll-margin-top: 100px;
    }

    .signup-container {
        max-width: 800px;
        margin: 0 auto;
    }

    .signup-header {
        text-align: center;
        margin-bottom: 40px;
    }

    .signup-header h2 {
        font-size: 2.4em;
        color: #007bff;
        font-weight: 700;
        margin-bottom: 20px;
    }

    .signup-header p {
        font-size: 1.2em;
        color: #007bff;
        opacity: 0.8;
        max-width: 600px;
        margin: 0 auto;
    }

    .signup-header a {
        color: #007bff;
        text-decoration: underline;
    }

    .signup-form {
        background: rgba(255, 255, 255, 0.9);
        border-radius: 24px;
        padding: 40px;
        box-shadow: 0 20px 40px rgba(0, 123, 255, 0.1);
        border: 1px solid rgba(0, 123, 255, 0.1);
        backdrop-filter: blur(20px);
        display: none;
    }

    .signup-form h3 {
        font-size: 1.8em;
        color: #007bff;
        font-weight: 600;
        margin-bottom: 20px;
        text-align: center;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .signup-form label {
        display: block;
        margin-top: 15px;
        font-weight: 500;
        color: #007bff;
        font-size: 0.95em;
    }

    .signup-form input, .signup-form select {
        width: 100%;
        padding: 12px;
        margin-top: 5px;
        border: 1px solid rgba(0, 123, 255, 0.2);
        border-radius: 8px;
        font-size: 0.95em;
        color: #007bff;
        background: rgba(255, 255, 255, 0.8);
        transition: border-color 0.3s ease, box-shadow 0.3s ease;
    }

    .signup-form input:focus, .signup-form select:focus {
        border-color: #007bff;
        box-shadow: 0 0 8px rgba(0, 123, 255, 0.2);
        outline: none;
    }

    .signup-form button {
        display: block;
        width: 100%;
        padding: 12px;
        background: #007bff;
        color: #fffafa;
        border: none;
        border-radius: 50px;
        font-weight: 600;
        font-size: 0.95em;
        margin-top: 20px;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
    }

    .signup-form button:hover {
        background: #0056b3;
        transform: translateY(-1px);
        box-shadow: 0 6px 16px rgba(0, 123, 255, 0.4);
    }

    .progress {
        text-align: center;
        font-weight: 600;
        font-size: 1.1em;
        color: #007bff;
        opacity: 0.8;
        margin-bottom: 20px;
        position: relative;
    }

    .progress-bar {
        display: flex;
        justify-content: space-between;
        margin: 10px auto;
        max-width: 400px;
    }

    .progress-step {
        width: 25%;
        height: 6px;
        background: rgba(0, 123, 255, 0.2);
        border-radius: 3px;
        transition: background 0.3s ease;
    }

    .progress-step.active {
        background: #007bff;
    }

    .form-page {
        display: none;
        opacity: 0;
        transform: translateY(20px);
        transition: opacity 0.3s ease, transform 0.3s ease;
    }

    .form-page.active {
        display: block;
        opacity: 1;
        transform: translateY(0);
    }

    .form-page h2 {
        text-align: center;
        font-size: 2em;
        color: #007bff;
        font-weight: 700;
        margin-bottom: 20px;
    }

    .form-page p {
        text-align: center;
        color: #007bff;
        opacity: 0.8;
        font-size: 1.1em;
        margin-bottom: 20px;
    }

    .checkbox-group {
        margin-top: 15px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .checkbox-group input {
        width: 18px;
        height: 18px;
        accent-color: #007bff;
        cursor: pointer;
    }

    .checkbox-group label {
        margin-top: 0;
        font-weight: 400;
        font-size: 1em;
    }

    .requirements-list {
        color: #007bff;
        opacity: 0.8;
        font-size: 1em;
        line-height: 1.7;
        margin-bottom: 20px;
    }

    .requirements-list ul {
        list-style: disc;
        margin-left: 20px;
    }

    .requirements-list ul ul {
        list-style: circle;
        margin-left: 20px;
    }

    .button-group {
        margin-top: 30px;
        display: flex;
        justify-content: space-between;
        gap: 20px;
    }

    .button-group button {
        flex: 1;
        margin-top: 0;
    }

    @media (max-width: 1024px) {
        .driver-signup {
            padding: 60px 40px;
        }
        .signup-form {
            padding: 30px;
        }
    }

    @media (max-width: 768px) {
        .driver-signup {
            padding: 60px 30px;
        }
        .signup-form {
            padding: 30px;
        }
        .button-group {
            flex-direction: column;
            gap: 15px;
        }
        .signup-header h2 {
            font-size: 2.2em;
        }
        .signup-form h3 {
            font-size: 1.6em;
        }
    }

    @media (max-width: 480px) {
        .driver-signup {
            padding: 50px 20px;
        }
        .signup-form {
            padding: 20px;
        }
        .signup-header h2 {
            font-size: 2em;
        }
        .signup-form h3 {
            font-size: 1.4em;
        }
        .signup-form input, .signup-form select {
            padding: 10px;
            font-size: 0.9em;
        }
        .signup-form button {
            padding: 10px;
            font-size: 0.9em;
        }
        .checkbox-group input {
            width: 16px;
            height: 16px;
        }
        .checkbox-group label {
            font-size: 0.95em;
        }
        .progress {
            font-size: 1em;
        }
    }


</style>
<body>
    <header class="navbar">
        <div class="logo">
            <img src="resources/EasyRide.png" alt="EasyRide Logo">
            <span>EasyRide <strong>NORSU</strong></span>
        </div>
        
        <button class="hamburger" id="hamburger" aria-label="Toggle navigation" aria-expanded="false">
            <span></span>
            <span></span>
            <span></span>
        </button>

        <div class="nav-container" id="navContainer">
            <nav>
                <ul>
                    <li><a href="#home" class="active">Home</a></li>
                    
                    <li><a href="#services">Services</a></li>
                    <li><a href="#coverage">Coverage Areas</a></li>
                    <li><a href="#contact">Contact Us</a></li>
                    <!-- <li><a href="signup">Be Our Driver</a></li> -->
                </ul>
            </nav>
            <div class="get-app">
                <a href="#driver-signup" class="btn-app">Be our Driver</a>
            </div>
        </div>
    </header>

    <div class="mobile-nav-overlay" id="mobileOverlay"></div>

    <section class="hero" id="home">
        <div class="hero-text">
            <h1>Book an EasyRide<br>anytime, anywhere</h1>
            <p>Your trusted campus mobility partner at NORSU-BSC — making student transport easier and more convenient</p>
            
            <div class="custom-store-buttons">
                <a href="#" class="custom-store-button">
                    <svg class="store-icon" viewBox="0 0 24 24">
                        <path d="M3,20.5V3.5C3,2.91 3.34,2.39 3.84,2.15L13.69,12L3.84,21.85C3.34,21.61 3,21.09 3,20.5M16.81,15.12L6.05,21.34L14.54,12.85L16.81,15.12M20.16,10.81C20.5,11.08 20.75,11.5 20.75,12C20.75,12.5 20.53,12.9 20.18,13.18L17.89,14.5L15.39,12L17.89,9.5L20.16,10.81M6.05,2.66L16.81,8.88L14.54,11.15L6.05,2.66Z"/>
                    </svg>
                    <div class="button-text">
                        <span class="small">GET IT ON</span>
                        <span class="large">Google Play</span>
                    </div>
                </a>
                <a href="#" class="custom-store-button">
                    <svg class="store-icon" viewBox="0 0 24 24">
                        <path d="M18.71,19.5C17.88,20.74 17,21.95 15.66,21.97C14.32,22 13.89,21.18 12.37,21.18C10.84,21.18 10.37,21.95 9.1,22C7.79,22.05 6.8,20.68 5.96,19.47C4.25,17 2.94,12.45 4.7,9.39C5.57,7.87 7.13,6.91 8.82,6.88C10.1,6.86 11.32,7.75 12.11,7.75C12.89,7.75 14.37,6.68 15.92,6.84C16.57,6.87 18.39,7.1 19.56,8.82C19.47,8.88 17.39,10.1 17.41,12.63C17.44,15.65 20.06,16.66 20.09,16.67C20.06,16.74 19.67,18.11 18.71,19.5M13,3.5C13.73,2.67 14.94,2.04 15.94,2C16.07,3.17 15.6,4.35 14.9,5.19C14.21,6.04 13.07,6.7 11.95,6.61C11.8,5.46 12.36,4.26 13,3.5Z"/>
                    </svg>
                    <div class="button-text">
                        <span class="small">Download on the</span>
                        <span class="large">App Store</span>
                    </div>
                </a>
            </div>
        </div>
        <div class="hero-image">
            <img src="resources/Model.png" alt="Smartphone with EasyRide Homepage">
            <a href="signup" class="book-now">Book Now</a>
        </div>
    </section>

    <section class="services" id="services">
        <div class="services-container">
            <div class="services-header">
                <h2>Our Services</h2>
                <p>Discover the range of transportation solutions we offer to make your campus experience seamless</p>
            </div>
            
            <div class="services-grid">
                <div class="service-card">
                    <div class="service-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M12,1L3,5V11C3,16.55 6.84,21.74 12,23C17.16,21.74 21,16.55 21,11V5L12,1M12,7C13.4,7 14.8,8.6 14.8,10V11.5C15.4,11.9 16,12.4 16,13V16C16,17.1 15.1,18 14,18H10C8.9,18 8,17.1 8,16V13C8,12.4 8.4,11.9 9,11.5V10C9,8.6 10.6,7 12,7M12,8.2C11.2,8.2 10.2,8.7 10.2,10V11.5H13.8V10C13.8,8.7 12.8,8.2 12,8.2Z"/>
                        </svg>
                    </div>
                    <div class="service-content">
                        <h3>Safe Rides</h3>
                        <p>Travel with peace of mind knowing every ride is secure with real-time tracking and verified drivers.</p>
                        <div class="service-highlights">
                            <div class="service-highlight">
                                <svg viewBox="0 0 24 24">
                                    <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z"/>
                                </svg>
                                <span>Background-checked drivers</span>
                            </div>
                            <div class="service-highlight">
                                <svg viewBox="0 0 24 24">
                                    <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z"/>
                                </svg>
                                <span>Real-time GPS tracking</span>
                            </div>
                            <div class="service-highlight">
                                <svg viewBox="0 0 24 24">
                                    <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z"/>
                                </svg>
                                <span>Emergency contact system</span>
                            </div>
                            <div class="service-highlight">
                                <svg viewBox="0 0 24 24">
                                    <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z"/>
                                </svg>
                                <span>Campus security integration</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="service-card">
                    <div class="service-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M19,3H5C3.89,3 3,3.89 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V5C21,3.89 20.1,3 19,3M19,5V7H5V5H19M5,19V9H19V19H5M6,10V12H8V10H6M9,10V12H15V10H9M16,10V12H18V10H16M6,13V15H8V13H6M9,13V15H15V13H9M16,13V15H18V13H16M6,16V18H8V16H6M9,16V18H15V16H9M16,16V18H18V16H16Z"/>
                        </svg>
                    </div>
                    <div class="service-content">
                        <h3>Easy Booking</h3>
                        <p>Book your ride in seconds with our intuitive app, tailored for quick and seamless reservations.</p>
                        <div class="service-highlights">
                            <div class="service-highlight">
                                <svg viewBox="0 0 24 24">
                                    <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z"/>
                                </svg>
                                <span>One-tap booking system</span>
                            </div>
                            <div class="service-highlight">
                                <svg viewBox="0 0 24 24">
                                    <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z"/>
                                </svg>
                                <span>Schedule rides in advance</span>
                            </div>
                            <div class="service-highlight">
                                <svg viewBox="0 0 24 24">
                                    <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z"/>
                                </svg>
                                <span>Multiple payment options</span>
                            </div>
                            <div class="service-highlight">
                                <svg viewBox="0 0 24 24">
                                    <path d="M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z"/>
                                </svg>
                                <span>Instant ride confirmation</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="coverage" id="coverage">
        <div class="coverage-container">
            <div class="coverage-header">
                <h2>Coverage Areas</h2>
                <p>We proudly serve the following areas around NORSU-BSC to keep you connected</p>
            </div>
            
            <div class="coverage-grid">
                <div class="coverage-card">
                    <div class="coverage-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M12,11.5A2.5,2.5 0 0,1 9.5,9A2.5,2.5 0 0,1 12,6.5A2.5,2.5 0 0,1 14.5,9A2.5,2.5 0 0,1 12,11.5M12,2A7,7 0 0,0 5,9C5,14.25 12,22 12,22C12,22 19,14.25 19,9A7,7 0 0,0 12,2Z"/>
                        </svg>
                    </div>
                    <div class="coverage-content">
                        <h3>Bayawan City</h3>
                        <p>Our primary service area, covering all key locations within Bayawan City for convenient campus commuting.</p>
                    </div>
                </div>

                <div class="coverage-card">
                    <div class="coverage-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M12,11.5A2.5,2.5 0 0,1 9.5,9A2.5,2.5 0 0,1 12,6.5A2.5,2.5 0 0,1 14.5,9A2.5,2.5 0 0,1 12,11.5M12,2A7,7 0 0,0 5,9C5,14.25 12,22 12,22C12,22 19,14.25 19,9A7,7 0 0,0 12,2Z"/>
                        </svg>
                    </div>
                    <div class="coverage-content">
                        <h3>Sta. Catalina</h3>
                        <p>Extending our services to Sta. Catalina, ensuring students have reliable transport options.</p>
                    </div>
                </div>

                <div class="coverage-card">
                    <div class="coverage-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M12,11.5A2.5,2.5 0 0,1 9.5,9A2.5,2.5 0 0,1 12,6.5A2.5,2.5 0 0,1 14.5,9A2.5,2.5 0 0,1 12,11.5M12,2A7,7 0 0,0 5,9C5,14.25 12,22 12,22C12,22 19,14.25 19,9A7,7 0 0,0 12,2Z"/>
                        </svg>
                    </div>
                    <div class="coverage-content">
                        <h3>Basay</h3>
                        <p>Providing coverage in Basay to support students traveling to and from campus.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>


<section class="contact" id="contact">
    <div class="contact-container">
        <div class="contact-header">
            <h2>Contact Us</h2>
            <p>Have questions or need assistance? Reach out to our team, and we’ll get back to you promptly.</p>
        </div>
        
        <div class="contact-form">
            <h3>Send Us a Message</h3>
            <form id="contactForm" action="submit_contact" method="POST">
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" required placeholder="Enter your name">
                </div>
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required placeholder="Enter your email">
                </div>
                <div class="form-group">
                    <label for="subject">Subject</label>
                    <input type="text" id="subject" name="subject" required placeholder="Enter the subject">
                </div>
                <div class="form-group">
                    <label for="message">Message</label>
                    <textarea id="message" name="message" required placeholder="Your message here"></textarea>
                </div>
                <button type="submit">Submit</button>
            </form>
        </div>

        <div class="contact-info">
            <p><strong>Email:</strong> <a href="mailto:support@easyride-norsu.com">support@easyride-norsu.com</a></p>
            <p><strong>Phone:</strong> <a href="tel:+639123456789">+63 912 345 6789</a></p>
            <p><strong>Address:</strong> NORSU-BSC Campus, Bayawan City, Negros Oriental, Philippines</p>
        </div>
    </div>
</section>



<section class="driver-signup" id="driver-signup">
    <div class="signup-container">
        <div class="signup-header">
            <h2>Become a Driver</h2>
            <p>Join the EasyRide team and start earning as a motorcycle taxi driver. Review the requirements and sign up today!</p>
            <a onclick="toggleForm()">See Requirements</a>
        </div>
        
        <div class="signup-form" id="signupForm">
            <h3>Driver Pre-Registration</h3>
            <form id="driverForm" action="DriverApplicationFormServlet" method="post">
                <!-- Page 1: Requirements -->
                <div class="form-page active" id="page1">
                    <h2>Requirements</h2>
                    <div class="progress">Page 1 of 4
                        <div class="progress-bar">
                            <div class="progress-step active"></div>
                            <div class="progress-step"></div>
                            <div class="progress-step"></div>
                            <div class="progress-step"></div>
                        </div>
                    </div>

                    <div class="requirements-list">
                        <ul>
                            <li>Age: 20 - 55 Years Old</li>
                            <li>Professional Driver's License</li>
                            <li>NBI Clearance</li>
                            <li>Police or Barangay Clearance</li>
                            <li>Vehicle OR/CR</li>
                            <li>Vehicle to be used:
                                <ul>
                                    <li>Motorcycle (Any Brand)</li>
                                    <li>Not older than 7 years</li>
                                    <li>Piston Displacement: 110 to 160cc</li>
                                    <li>Vehicle Photos (Front, Side, Back)</li>
                                </ul>
                            </li>
                            <li>Other conditions:
                                <ul>
                                    <li>Borrowed/Rented: Valid ID + Authorization Letter</li>
                                    <li>Second Hand: ID + Notarized Deed of Sale</li>
                                    <li>Repossessed: Repo Sales Form/Certificate</li>
                                </ul>
                            </li>
                            <li>Age 50+: Fit to Work Medical Certificate</li>
                            <li>Android Phone (Version 8.0 and up)</li>
                            <li>App to download: EasyRide Driver App</li>
                        </ul>
                    </div>

                    <div class="button-group">
                        <button type="button" onclick="nextPage()">Next</button>
                    </div>
                </div>

                <!-- Page 2: Service and Base Office -->
                <div class="form-page" id="page2">
                    <h2>EasyRide Motorcycle Taxi Pre-Registration</h2>
                    <div class="progress">Page 2 of 4
                        <div class="progress-bar">
                            <div class="progress-step active"></div>
                            <div class="progress-step active"></div>
                            <div class="progress-step"></div>
                            <div class="progress-step"></div>
                        </div>
                    </div>

                    <p>Welcome! Thank you for signing up.</p>

                    <div class="form-group">
                        <label>Service you want to join:</label>
                        <div class="checkbox-group">
                            <input type="checkbox" name="service" value="Motorcycle Taxi" required>
                            <label>Motorcycle Taxi</label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Base Office:</label>
                        <div class="checkbox-group">
                            <input type="checkbox" name="baseOffice" value="Norsu - BSC" required>
                            <label>Norsu - BSC</label>
                        </div>
                    </div>

                    <div class="button-group">
                        <button type="button" onclick="prevPage()">Back</button>
                        <button type="button" onclick="nextPage()">Next</button>
                    </div>
                </div>

                <!-- Page 3: Personal Information -->
                <div class="form-page" id="page3">
                    <h2>Personal Information</h2>
                    <div class="progress">Page 3 of 4
                        <div class="progress-bar">
                            <div class="progress-step active"></div>
                            <div class="progress-step active"></div>
                            <div class="progress-step active"></div>
                            <div class="progress-step"></div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>First Name</label>
                        <input type="text" name="firstName" required placeholder="Enter your first name">
                    </div>

                    <div class="form-group">
                        <label>Last Name</label>
                        <input type="text" name="lastName" required placeholder="Enter your last name">
                    </div>

                    <div class="form-group">
                        <label>Mobile Number</label>
                        <input type="tel" name="mobileNumber" required placeholder="Enter your mobile number">
                    </div>

                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" name="email" required placeholder="Enter your email">
                    </div>

                    <div class="form-group">
                        <label>City / Province / Town</label>
                        <select name="city" required>
                            <option value="">-- Select City --</option>
                            <option value="Negros Oriental - Basay">Negros Oriental - Basay</option>
                            <option value="Negros Oriental - Bayawan">Negros Oriental - Bayawan</option>
                            <option value="Negros Oriental - Santa Catalina">Negros Oriental - Santa Catalina</option>
                        </select>
                    </div>

                    <div class="button-group">
                        <button type="button" onclick="prevPage()">Back</button>
                        <button type="submit" >Submit</button>
                    </div>
                </div>

                <!-- Page 4: Thank You -->
                <div class="form-page" id="page4">
                    <h2>Thank You!</h2>
                    <div class="progress">Page 4 of 4
                        <div class="progress-bar">
                            <div class="progress-step active"></div>
                            <div class="progress-step active"></div>
                            <div class="progress-step active"></div>
                            <div class="progress-step active"></div>
                        </div>
                    </div>

                    <p>Thank you for filling out our EasyRide Motorcycle Taxi Pre-Registration Form!</p>
                    <p>Stay tuned for updates or visit our office at Norsu-BSC.</p>

                    <div class="button-group">
                        <button href="#home" type="submit">Submit</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</section>

<script>
    function toggleForm() {
        const form = document.getElementById('signupForm');
        const isHidden = form.style.display === 'none' || form.style.display === '';
        form.style.display = isHidden ? 'block' : 'none';
        if (isHidden) {
            showPage(1); // Reset to Page 1 (Requirements)
        }
    }

    let currentPage = 1;
    const totalPages = 4;

    function showPage(pageNum) {
        for (let i = 1; i <= totalPages; i++) {
            const page = document.getElementById('page' + i);
            if (page) {
                page.classList.remove('active');
            }
        }
        const targetPage = document.getElementById('page' + pageNum);
        if (targetPage) {
            targetPage.classList.add('active');
            currentPage = pageNum;
            const progressSteps = document.querySelectorAll('.progress-step');
            progressSteps.forEach((step, index) => {
                step.classList.toggle('active', index < pageNum);
            });
        }
    }

    function nextPage() {
        const currentFormPage = document.getElementById('page' + currentPage);
        const inputs = currentFormPage.querySelectorAll('input[required], select[required]');
        
        // Skip validation for Page 1 (Requirements, no inputs)
        if (currentPage === 1) {
            if (currentPage < totalPages) {
                showPage(currentPage + 1);
            }
            return;
        }

        // Validate required fields
        for (let input of inputs) {
            if (input.type === "checkbox" && !input.checked) {
                alert(`Please check the required ${input.name} option.`);
                return;
            }
            if ((input.type === "text" || input.type === "email" || input.type === "tel" || input.tagName.toLowerCase() === "select") && !input.value.trim()) {
                alert(`Please fill in the ${input.name} field.`);
                return;
            }
        }

        // Handle Page 3 submission
        if (currentPage === 3) {
            const form = document.getElementById('driverForm');
            const formData = new FormData(form);
            fetch('/DriverApplicationFormServlet', {
                method: 'POST',
                body: formData
            }).then(response => {
                if (response.ok) {
                    showPage(4); // Show Thank You page
                    form.reset(); // Clear form data
                } else {
                    alert('Submission failed. Please try again.');
                }
            }).catch(() => alert('Network error. Please try again.'));
            return;
        }

        // Navigate to next page (Page 2)
        if (currentPage < totalPages) {
            showPage(currentPage + 1);
        }
    }

    function prevPage() {
        if (currentPage > 1) {
            showPage(currentPage - 1);
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        const form = document.getElementById('signupForm');
        form.style.display = 'none'; // Hide form on load
        showPage(1); // Initialize Page 1
        // Smooth scrolling for #home link
        document.querySelectorAll('a[href^="#"]').forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const targetId = link.getAttribute('href').substring(1);
                const targetElement = document.getElementById(targetId);
                if (targetElement) {
                    window.scrollTo({
                        top: targetElement.offsetTop - 80,
                        behavior: 'smooth'
                    });
                }
            });
        });
    });

    // Expose functions for onclick handlers
    window.nextPage = nextPage;
    window.prevPage = prevPage;
</script>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const hamburger = document.getElementById('hamburger');
            const navContainer = document.getElementById('navContainer');
            const mobileOverlay = document.getElementById('mobileOverlay');
            const navLinks = document.querySelectorAll('nav ul li a');

            // Hamburger menu toggle
            hamburger.addEventListener('click', () => {
                const isExpanded = hamburger.classList.toggle('active');
                hamburger.setAttribute('aria-expanded', isExpanded);
                navContainer.classList.toggle('active');
                mobileOverlay.classList.toggle('active');
            });

            mobileOverlay.addEventListener('click', () => {
                hamburger.classList.remove('active');
                hamburger.setAttribute('aria-expanded', 'false');
                navContainer.classList.remove('active');
                mobileOverlay.classList.remove('active');
            });

            // Smooth scroll for nav links
            navLinks.forEach(link => {
                link.addEventListener('click', (e) => {
                    e.preventDefault();
                    const targetId = link.getAttribute('href').substring(1);
                    const targetElement = document.getElementById(targetId);
                    if (targetElement) {
                        window.scrollTo({
                            top: targetElement.offsetTop - 80, // Adjust for fixed navbar
                            behavior: 'smooth'
                        });
                    }
                });
            });

            // Add scrolled class to navbar on scroll
            window.addEventListener('scroll', () => {
                const navbar = document.querySelector('.navbar');
                if (window.scrollY > 50) {
                    navbar.classList.add('scrolled');
                } else {
                    navbar.classList.remove('scrolled');
                }
            });

            // Debug click handler for Book Now button
            document.querySelector('.book-now').addEventListener('click', () => {
                console.log('Book Now button clicked');
            });
        });
    </script>
</body>
</html>
