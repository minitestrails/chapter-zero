import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.querySelectorAll("pre.highlight").forEach((codeBlock) => {
      if (codeBlock.querySelector(".copy-code-button")) {
        return
      }

      const button = document.createElement("button")
      button.type = "button"
      button.className = "copy-code-button"
      button.setAttribute("data-action", "click->clipboard#copy")
      button.setAttribute("aria-label", "Copy code to clipboard")
      button.innerHTML = `
        <svg class="copy-icon" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
          <path d="M5.5 3.5h6a1 1 0 0 1 1 1v6a1 1 0 0 1-1 1h-6a1 1 0 0 1-1-1v-6a1 1 0 0 1 1-1z"/>
          <path d="M3.5 5.5h-1a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1v-1"/>
        </svg>
        <svg class="check-icon hidden" width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
          <path d="M13.5 4.5l-6 6-3-3"/>
        </svg>
      `

      codeBlock.appendChild(button)
    })
  }

  copy(event) {
    const button = event.currentTarget
    const codeBlock = button.closest("pre.highlight")
    const code = codeBlock?.querySelector("code")

    if (!code) return

    const text = code.textContent || code.innerText

    navigator.clipboard.writeText(text).then(() => {
      const copyIcon = button.querySelector(".copy-icon")
      const checkIcon = button.querySelector(".check-icon")

      copyIcon.classList.add("hidden")
      checkIcon.classList.remove("hidden")
      button.setAttribute("aria-label", "Copied!")

      setTimeout(() => {
        copyIcon.classList.remove("hidden")
        checkIcon.classList.add("hidden")
        button.setAttribute("aria-label", "Copy code to clipboard")
      }, 2000)
    }).catch((err) => {
      console.error("Failed to copy:", err)
      const textArea = document.createElement("textarea")
      textArea.value = text
      textArea.style.position = "fixed"
      textArea.style.opacity = "0"
      document.body.appendChild(textArea)
      textArea.select()
      try {
        document.execCommand("copy")
        button.setAttribute("aria-label", "Copied!")
        setTimeout(() => {
          button.setAttribute("aria-label", "Copy code to clipboard")
        }, 2000)
      } catch (fallbackErr) {
        console.error("Fallback copy failed:", fallbackErr)
      }
      document.body.removeChild(textArea)
    })
  }
}
