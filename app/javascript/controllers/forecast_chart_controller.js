import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const canvas = this.element.querySelector("canvas")

    const labels = JSON.parse(this.element.dataset.labels)
    const highs = JSON.parse(this.element.dataset.highs)
    const lows = JSON.parse(this.element.dataset.lows)

    this.chart = new window.Chart(canvas.getContext("2d"), {
      type: "line",
      data:
      {
        labels,
        datasets: [
          {
            label: "High (°F)",
            data: highs,
            borderColor: "rgb(239, 68, 68)",
            backgroundColor: "rgba(239, 68, 68, 0.25)"
          },
          {
            label: "Low (°F)",
            data: lows,
            borderColor: "rgb(59, 130, 246)",
            backgroundColor: "rgba(59, 130, 246, 0.25)"
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false
      }
    })
  }
  disconnect() {
    this.chart?.destroy()
  }
}
