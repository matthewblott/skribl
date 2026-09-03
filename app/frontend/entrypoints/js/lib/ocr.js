const ocr = (canvas) => {

  const markDirty = () => {
    canvas.dispatchEvent(new CustomEvent("canvas:dirty", {
      bubbles: true,    // optional but useful so Stimulus can catch it
    }));
  };

  const ctx = canvas.getContext('2d')
  const lineWidth = 3
  
  let hasDimensionsSet = false

  canvas.width = canvas.clientWidth
  canvas.height = canvas.clientHeight

  // We need a background colour for the pen-to-print api
  ctx.fillStyle = 'white'

  let isPainting = false
  let startX
  let startY

  //Mouse
  canvas.addEventListener('mousedown', (e) => {
    isPainting = true
    startX = e.clientX
    startY = e.clientY
    markDirty();
  })
  canvas.addEventListener('mousemove', e => {
    if (!isPainting) {
      return
    }
    ctx.lineWidth = lineWidth
    ctx.lineCap = 'round'
    ctx.lineTo(e.clientX - canvas.offsetLeft, e.clientY - canvas.offsetTop)
    ctx.stroke()
    markDirty();
  })
  canvas.addEventListener('mouseup', () => {
    isPainting = false
    ctx.stroke()
    ctx.beginPath()
    markDirty();
  })

  // Touch
  canvas.addEventListener('touchstart', (e) => {
    if (!hasDimensionsSet) {
      canvas.width = canvas.clientWidth
      canvas.height = canvas.clientHeight
      hasDimensionsSet = true
    }

    isPainting = true
    startX = e.touches[0].clientX
    startY = e.touches[0].clientY
    markDirty();
  })
  canvas.addEventListener('touchend', () => {
    isPainting = false
    ctx.stroke()
    ctx.beginPath()
    markDirty();
  })
  canvas.addEventListener('touchmove', e => {
    if (!isPainting) {
      return
    }
    ctx.lineWidth = lineWidth
    ctx.lineCap = 'round'
    ctx.lineTo(e.touches[0].clientX - canvas.offsetLeft, e.touches[0].clientY - canvas.offsetTop)
    ctx.stroke()
    markDirty();
  })
}

export { ocr }

