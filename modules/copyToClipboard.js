document.addEventListener('DOMContentLoaded', function() {
  const preElements = document.querySelectorAll('pre');

  preElements.forEach(pre => {
    const codeElement = pre.querySelector('code');
    if (codeElement) {
      const copyButton = document.createElement('button');
      copyButton.className = 'copy-button';
      copyButton.innerHTML = '📋'; // Clipboard emoji
      copyButton.setAttribute('title', 'Copy to Clipboard'); // Tooltip text

      copyButton.addEventListener('click', () => {
        const textToCopy = codeElement.textContent;
        navigator.clipboard.writeText(textToCopy).then(() => {
          copyButton.textContent = 'Copied!';
          setTimeout(() => {
            copyButton.innerHTML = '📋';
          }, 2000);
        }).catch(err => {
          console.error('Failed to copy text: ', err);
        });
      });

      pre.style.position = 'relative';
      pre.appendChild(copyButton);
    }
  });
});

export {}; // This makes the file a module
