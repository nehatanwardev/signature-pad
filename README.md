# Signature Pad App

This Flutter app allows users to draw and save digital signatures with customizable pen colors, canvas colors, and pen widths. It features a signature pad where users can sign directly on the canvas, a clear button to reset the signature, and an option to save and download the signature as an image.

## Features

- **Customizable Pen and Canvas Colors:** Pick your desired pen color and canvas background using a color picker.
- **Adjustable Pen Width:** Choose the thickness of the signature pen for fine control over signature details.
- **Save and Download Signature:** Save the signature as an image and download it locally or store it in web local storage for later use.
- **Clear Signature:** Reset the signature pad to start over.
- **Web and Mobile Support:** Works on both web (using localStorage and file download) and mobile (storing images in the app's local storage).

## Libraries and Packages Used

- **Flutter:** For building the app.
- **flutter_signature_pad:** For the signature pad.
- **screenshot:** For capturing the signature as an image.
- **flutter_colorpicker:** For color picking functionality.
- **path_provider:** To access device storage for saving images.
  
 ## Demo Link :  https://nehatanwardev.github.io/signature-pad/

## Getting Started

To get started, clone this repository and run the app on your preferred device using Flutter.

### Prerequisites

Make sure you have [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/nehatanwardev/signature-pad.git
