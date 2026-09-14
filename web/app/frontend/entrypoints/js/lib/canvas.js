const canvas = (element) => {

  const markDirty = () => {
    element.dispatchEvent(new CustomEvent("canvas:dirty", {
      bubbles: true,    // optional but useful so Stimulus can catch it
    }));
  };

  const ctx = element.getContext('2d')
  const lineWidth = 3
  
  let hasDimensionsSet = false

  element.width = element.clientWidth
  element.height = element.clientHeight

  // We need a background colour for the pen-to-print api
  ctx.fillStyle = 'white'

  let isPainting = false
  let startX
  let startY

  //Mouse
  element.addEventListener('mousedown', (e) => {
    isPainting = true
    startX = e.clientX
    startY = e.clientY
    markDirty();
  })
  element.addEventListener('mousemove', e => {
    if (!isPainting) {
      return
    }
    ctx.lineWidth = lineWidth
    ctx.lineCap = 'round'
    ctx.lineTo(e.clientX - element.offsetLeft, e.clientY - element.offsetTop)
    ctx.stroke()
    markDirty();
  })
  element.addEventListener('mouseup', () => {
    isPainting = false
    ctx.stroke()
    ctx.beginPath()
    markDirty();
  })

  // Touch
  element.addEventListener('touchstart', (e) => {
    if (!hasDimensionsSet) {
      element.width = element.clientWidth
      element.height = element.clientHeight
      hasDimensionsSet = true
    }

    isPainting = true
    startX = e.touches[0].clientX
    startY = e.touches[0].clientY
    markDirty();
  })
  element.addEventListener('touchend', () => {
    isPainting = false
    ctx.stroke()
    ctx.beginPath()
    markDirty();
  })
  element.addEventListener('touchmove', e => {
    if (!isPainting) {
      return
    }
    ctx.lineWidth = lineWidth
    ctx.lineCap = 'round'
    ctx.lineTo(e.touches[0].clientX - element.offsetLeft, e.touches[0].clientY - element.offsetTop)
    ctx.stroke()
    markDirty();
  })
}

export { canvas }
