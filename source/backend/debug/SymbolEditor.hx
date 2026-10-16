package backend.debug;

import backend.ui.HColorPicker;

class SymbolEditor extends HState {
	public var menuBar:HMenuBar;
	public var footerBar:HMenuBar;

	// editor stuffs.
	var editor:HSprite = null; // HSprite.
	var commands:Array<Dynamic> = [];
	var px:Int = 16; // zoom
	var snap:Bool = true;
	var dragIndex:Int = -1;
	var history:Array<Dynamic> = [];
	var origin:HPoint = new HPoint(40, 40);
	// drag/draw
	var drawing:Bool = false;
	var drawStartWorld:HPoint = new HPoint(0, 0);
	var drawStartScreen:HPoint = new HPoint(0, 0);
	var previewEnd:HPoint = new HPoint(0, 0);
	// pan
	var panning:Bool = false;
	var panStartScreen:HPoint = new HPoint(0, 0);
	var panStartOrigin:HPoint = new HPoint(0, 0);
	final CLICK_THRESHOLD_PX:Int = 5;
	final MIN_PX:Float = 0.5;
	final MAX_PX:Float = 4000;

	override function create() {
		super.create();
		trace("Editor launched");
		Main.addKeyPressed("SymbolGeneratorExitKey", Keyboard.ESCAPE, true, (_:KeyboardEvent) -> {
			Main.StateSystem.switchState(InitState);
		});

		try {
			menuBar = new HMenuBar(TOP, [
				new HCheckbox(0, 0, "Snap to grid", (_:Bool)->{trace('Grid should snap? $_');}, true),
				new HCheckbox(0, 0, "Show grid", (_:Bool)->{trace('Grid should show? $_');}, true),
				new HUISprite(0, 0).makeGraphic(2, 20, HColor.MENUBAR_DROPDOWN_BACKGROUND),
				new HUIText(0, 0, 35, "100%", 12),
				new HButton("Reset view", new Rectangle(0, 0, 75, 20), (_:HButton)->{trace('Attempting to reset view...');}, DEFAULT),
				new HUISprite(0, 0).makeGraphic(2, 20, HColor.MENUBAR_DROPDOWN_BACKGROUND),
				new HButton("Undo", new Rectangle(0, 0, 50, 20), (_:HButton)->{trace('Attempting to undo last change...');}, DEFAULT),
				new HButton("Clear all", new Rectangle(0, 0, 50, 20), (_:HButton)->{trace('Attempting to clear all changes...');}, DEFAULT)
			]);
			add(menuBar);

			var tabMenu:HTabMenu = new HTabMenu(Main.pWidth - 400, 0, new HPoint(400, Main.pHeight));
			add(tabMenu);

			var testGroup1:HGroup<HSprite> = new HGroup<HSprite>(0, 0);
			testGroup1.addChild(new HText(0, 0, 100, "group 1!", 12));

			/*Style group section*/
			var styleGroup:HGroup<OneOfTwo<HSprite, HText>> = new HGroup<OneOfTwo<HSprite, HText>>(0, 0);
			var t:HText = styleGroup.add(new HText(5, 5, 100, "FILL", 12));
			t.textColor = HColor.WHITE;
			var c = styleGroup.add(new HCheckbox(5, 25, "Enabled", (_:Bool) -> {
				trace('Enabled fill color? $_');
			}));
			cast(c, HCheckbox).label.textColor = HColor.WHITE;

			var c2 = styleGroup.add(new HColorPicker(5, 50, 160, 20, 0xFF5FD0C0, (_:Int) -> {
				trace('Fill color changed!');
			}));

			var testGroup3:HGroup<HSprite> = new HGroup<HSprite>(0, 0);
			testGroup3.addChild(new HText(0, 0, 100, "group 3!", 12));

			tabMenu.addGroup("first", testGroup1);
			tabMenu.addGroup("Style", styleGroup);
			tabMenu.addGroup("third", testGroup3);

			footerBar = new HMenuBar(BOTTOM, [
				new HUIText(0, 0, 410, "click: MOVE · drag: LINE · right-drag: move point · wheel: zoom · middle-drag: pan", 12),
				new HUISprite(0, 0).makeGraphic(2, 20, HColor.MENUBAR_DROPDOWN_BACKGROUND),
				new HUIText(0, 0, 420, "x: {X}, y: {Y}", 12),
			]);
			add(footerBar);
		} catch (e) {
			trace('Something went wrong! ${e.stack}');
		}
	}

	// actual editor functions n shiz
	function pushHistory() {
		history.push(Json.stringify(commands));
		history.length > 60 ? history.shift() : null;
	}

	inline function undo()
		history.length != 0 ? {commands = Json.parse(history.pop()); renderAll();} : null;

	inline function toScreen(x:Float, y:Float):HPoint
		return new HPoint(origin.x + x * px, origin.y + y * px);

	inline function toWorld(sx:Float, sy:Float, applySnap:Bool = true):HPoint
		return new HPoint((applySnap && snap) ? Math.round((sx - origin.x) / px) : (sx - origin.x) / px,
			(applySnap && snap) ? Math.round((sy - origin.y) / px) : (sy - origin.y) / px);

	inline function updateZoomReadout()
		cast(footerBar.members[2], HUIText).text = '${Std.string(Math.round(px / 16 * 100))}%';

	function hexToRgb(hex:String) {
		final n:Int = Std.parseInt(hex.replace('#', '').replace("0x", "").replace("0X", ""));
		return [(n >> 16) & 255, (n >> 8) & 255, n & 255];
	}

	function colorInputToHaxeHex(colorPicker) {
		// TODO: this.
		// return '0x' + colorPicker.value.replace('#','').toUpperCase();
	}

	// function nearestPointIndex(sx:Float, sy:Float, threshold:Int=12){
	//    var closest:Int = -1;
	//    var closestDist = threshold;
	//    commands.forEach((c, i)->{
	//        final a:HPoint=new HPoint(toScreen(c.x, c.y).x, toScreen(c.x, c.y).y);
	//        final d = Math.hypot(a.x-sx, a.y-sy);
	//
	//        if(d < closestDist){ closest = i; closestDist = d; }
	//    });
	//    return closest;
	// }
	// donothing.
	function renderAll() {}

	override public function destroy() {
		super.destroy();
	}
}
//      <div class="field-row"><label>alpha</label><input type="range" id="fillAlpha" min="0" max="1" step="0.01" value="1"><span class="val" id="fillAlphaVal">1.00</span></div>
//
//      <div class="divider"></div>
//      <p class="section-title">Outline (thickness / outlineColor)</p>
//      <div class="field-row"><label>enabled</label><input type="checkbox" id="strokeEnabled"></div>
//      <div class="field-row"><label>color</label><input type="color" id="strokeColor" value="#e0e6f0"><input type="text" id="strokeColorHex" value="0xE0E6F0" style="font-family:'JetBrains Mono',monospace;"></div>
//      <div class="field-row"><label>alpha</label><input type="range" id="strokeAlpha" min="0" max="1" step="0.01" value="1"><span class="val" id="strokeAlphaVal">1.00</span></div>
//      <div class="field-row"><label>thickness</label><input type="number" id="strokeThickness" value="1" min="0" max="20"></div>
//
//      <div class="divider"></div>
//      <p class="section-title">Icon meta</p>
//      <div class="field-row"><label>icon name</label><input type="text" id="iconName" value="mute"></div>
//    </div>
//
//    <div class="tabpane" id="tab-code">
//      <p class="section-title">Generated HDrawableIcons entry</p>
//      <textarea id="exportCode" readonly></textarea>
//      <div class="copybar">
//        <button id="copyBtn" class="primary">Copy</button>
//      </div>
//      <div class="divider"></div>
//      <p class="section-title">Import existing command array</p>
//      <textarea id="importCode" placeholder="Paste an HDrawableIconCommand array, e.g.&#10;[&#10;  {t:MOVE,a:{x:0,y:0}},&#10;  {t:LINE,a:{x:10,y:10}}&#10;]"></textarea>
//      <div class="copybar">
//        <button id="importBtn" class="primary">Parse & load</button>
//      </div>
//      <div class="small-note" id="importMsg"></div>
//    </div>
//  </aside>
// </main>
//  function drawGrid(){
//    // pick a "nice" world-unit step so lines never get overwhelmingly dense or sparse,
//    // however far zoomed in/out (1, 2, 5, 10, 20, 50 ... pattern)
//    const targetPx = 28; // aim for roughly this many screen px between lines
//    const rawStep = targetPx / px;
//    const mag = Math.pow(10, Math.floor(Math.log10(rawStep)));
//    const norm = rawStep / mag;
//    const niceNorm = norm < 1.5 ? 1 : norm < 3.5 ? 2 : norm < 7.5 ? 5 : 10;
//    const step = niceNorm * mag;
//    const majorEvery = 5; // every 5th line drawn brighter, as a sub-grid landmark
//
//    const worldLeft   = (0 - originX) / px;
//    const worldRight  = (canvas.width - originX) / px;
//    const worldTop    = (0 - originY) / px;
//    const worldBottom = (canvas.height - originY) / px;
//
//    const startI = Math.floor(worldLeft / step);
//    const endI   = Math.ceil(worldRight / step);
//    const startJ = Math.floor(worldTop / step);
//    const endJ   = Math.ceil(worldBottom / step);
//
//    ctx.save();
//    ctx.lineWidth = 1;
//    ctx.font = '9px JetBrains Mono, monospace';
//
//    for(let i = startI; i <= endI; i++){
//      const wx = i * step;
//      const [sx] = toScreen(wx, 0);
//      const isMajor = i % majorEvery === 0;
//      ctx.strokeStyle = isMajor ? '#2c3342' : '#1e232d';
//      ctx.beginPath();
//      ctx.moveTo(sx, 0); ctx.lineTo(sx, canvas.height);
//      ctx.stroke();
//      if(isMajor && wx !== 0){
//        ctx.fillStyle = '#4a5266';
//        ctx.fillText(fmt(wx), sx + 3, 11);
//      }
//    }
//    for(let j = startJ; j <= endJ; j++){
//      const wy = j * step;
//      const [,sy] = toScreen(0, wy);
//      const isMajor = j % majorEvery === 0;
//      ctx.strokeStyle = isMajor ? '#2c3342' : '#1e232d';
//      ctx.beginPath();
//      ctx.moveTo(0, sy); ctx.lineTo(canvas.width, sy);
//      ctx.stroke();
//      if(isMajor && wy !== 0){
//        ctx.fillStyle = '#4a5266';
//        ctx.fillText(fmt(wy), 3, sy - 3);
//      }
//    }
//    ctx.restore();
//  }
//
//
//  function draw(){
//    ctx.clearRect(0,0,canvas.width,canvas.height);
//
//    if(document.getElementById('showGrid').checked){
//      drawGrid();
//    }
//
//    // axes
//    ctx.strokeStyle = '#3a4152';
//    ctx.lineWidth = 1.5;
//    ctx.beginPath();
//    ctx.moveTo(originX, 0); ctx.lineTo(originX, canvas.height);
//    ctx.moveTo(0, originY); ctx.lineTo(canvas.width, originY);
//    ctx.stroke();
//
//    if(commands.length){
//      const fillEnabled = document.getElementById('fillEnabled').checked;
//      const fillAlpha = parseFloat(document.getElementById('fillAlpha').value);
//      const fillColor = document.getElementById('fillColor').value;
//      const strokeEnabled = document.getElementById('strokeEnabled').checked;
//      const strokeAlpha = parseFloat(document.getElementById('strokeAlpha').value);
//      const strokeColor = document.getElementById('strokeColor').value;
//      const thickness = parseFloat(document.getElementById('strokeThickness').value) || 1;
//
//      ctx.beginPath();
//      let started = false;
//      for(const c of commands){
//        const [sx,sy] = toScreen(c.x, c.y);
//        if(c.t === 'MOVE'){ ctx.moveTo(sx,sy); started = true; }
//        else { if(!started){ ctx.moveTo(sx,sy); started = true; } else ctx.lineTo(sx,sy); }
//      }
//      if(fillEnabled){
//        ctx.fillStyle = fillColor; ctx.globalAlpha = fillAlpha;
//        ctx.fill();
//        ctx.globalAlpha = 1;
//      }
//      if(strokeEnabled){
//        ctx.strokeStyle = strokeColor; ctx.globalAlpha = strokeAlpha; ctx.lineWidth = thickness;
//        ctx.stroke();
//        ctx.globalAlpha = 1;
//      }
//    }
//
//    // points + order
//    commands.forEach((c,i)=>{
//      const [sx,sy] = toScreen(c.x,c.y);
//      ctx.beginPath();
//      ctx.arc(sx,sy, i===dragIndex?6:5, 0, Math.PI*2);
//      ctx.fillStyle = c.t==='MOVE' ? '#e8a33d' : '#5fa8e8';
//      ctx.fill();
//      ctx.strokeStyle = '#0d1015'; ctx.lineWidth = 1.5; ctx.stroke();
//      ctx.fillStyle = '#c9d3e0';
//      ctx.font = '10px JetBrains Mono, monospace';
//      ctx.fillText(i, sx+7, sy-6);
//    });
//
//    // live preview while dragging out a new LINE
//    if(drawing && drawStartWorld && previewEnd){
//      const [sx1,sy1] = toScreen(drawStartWorld[0], drawStartWorld[1]);
//      const [sx2,sy2] = toScreen(previewEnd[0], previewEnd[1]);
//      ctx.save();
//      ctx.setLineDash([4,4]);
//      ctx.strokeStyle = '#5fa8e8';
//      ctx.lineWidth = 1.5;
//      ctx.beginPath();
//      ctx.moveTo(sx1,sy1);
//      ctx.lineTo(sx2,sy2);
//      ctx.stroke();
//      ctx.restore();
//    }
//  }
//
//  function renderList(){
//    const list = document.getElementById('cmdList');
//    if(!commands.length){
//      list.innerHTML = '<div class="empty-note">No commands yet. Pick MOVE or LINE above, then click on the canvas.</div>';
//      return;
//    }
//    list.innerHTML = '';
//    commands.forEach((c,i)=>{
//      const row = document.createElement('div');
//      row.className = 'cmd-row';
//      row.innerHTML = `
//        <span class="idx">#${i}</span>
//        <select class="${c.t}" data-i="${i}" data-f="t">
//          <option value="MOVE" ${c.t==='MOVE'?'selected':''}>MOVE</option>
//          <option value="LINE" ${c.t==='LINE'?'selected':''}>LINE</option>
//        </select>
//        <input type="number" value="${c.x}" data-i="${i}" data-f="x">
//        <input type="number" value="${c.y}" data-i="${i}" data-f="y">
//        <button class="del" data-i="${i}" title="delete">✕</button>
//      `;
//      list.appendChild(row);
//    });
//    list.querySelectorAll('select,input[type=number]').forEach(el=>{
//      el.addEventListener('change', e=>{
//        pushHistory();
//        const i = +e.target.dataset.i, f = e.target.dataset.f;
//        commands[i][f] = f==='t' ? e.target.value : parseFloat(e.target.value)||0;
//        renderAll();
//      });
//    });
//    list.querySelectorAll('.del').forEach(el=>{
//      el.addEventListener('click', e=>{
//        pushHistory();
//        commands.splice(+e.target.dataset.i, 1);
//        renderAll();
//      });
//    });
//  }
//
//  function generateCode(){
//    const iconName = document.getElementById('iconName').value.trim() || 'myIcon';
//    const lines = commands.map(c=>`        {t:${c.t}, a:{x:${fmt(c.x)}, y:${fmt(c.y)}}},`).join('\n');
//    const fillColor = colorInputToHaxeHex(document.getElementById('fillColor'));
//    const fillAlpha = document.getElementById('fillAlpha').value;
//    const strokeEnabled = document.getElementById('strokeEnabled').checked;
//    const strokeColor = colorInputToHaxeHex(document.getElementById('strokeColor'));
//    const strokeAlpha = document.getElementById('strokeAlpha').value;
//    const thickness = document.getElementById('strokeThickness').value;
//
//    let out = `// Add to HDrawableIcons:\npublic static final ${iconName}:Array<HDrawableIconCommand> = [\n${lines || '        // no commands yet'}\n];\n\n`;
//    out += `// Usage:\nDrawUtil.drawIcon(spr, "${iconName}", ${strokeEnabled?thickness:0}, new HColor(${strokeColor}, ${strokeEnabled?strokeAlpha:0}), new HColor(${fillColor}, ${fillAlpha}));`;
//    document.getElementById('exportCode').value = out;
//  }
//  function fmt(n){ return Number.isInteger(n) ? n : Math.round(n*100)/100; }
//
//  function renderAll(){
//    draw();
//    renderList();
//    generateCode();
//  }
//
//  // --- canvas interaction ---
//
//  // right-click's default context menu would otherwise block right-drag
//  canvas.addEventListener('contextmenu', e=> e.preventDefault());
//
//  canvas.addEventListener('mousemove', e=>{
//    const [sx,sy] = getMousePos(e);
//    const [wx,wy] = toWorld(sx,sy);
//    coordHint.textContent = `x: ${wx}, y: ${wy}`;
//
//    if(panning){
//      const dx = sx - panStartScreen[0], dy = sy - panStartScreen[1];
//      originX = panStartOrigin[0] + dx;
//      originY = panStartOrigin[1] + dy;
//      draw();
//      return;
//    }
//    if(dragIndex >= 0){
//      commands[dragIndex].x = wx; commands[dragIndex].y = wy;
//      renderAll();
//      return;
//    }
//    if(drawing){
//      previewEnd = [wx, wy];
//      draw();
//    }
//  });
//
//  canvas.addEventListener('mousedown', e=>{
//    const [sx,sy] = getMousePos(e);
//
//    if(e.button === 1){ // middle click: pan
//      e.preventDefault();
//      panning = true;
//      panStartScreen = [sx,sy];
//      panStartOrigin = [originX, originY];
//      canvas.style.cursor = 'grabbing';
//      return;
//    }
//
//    if(e.button === 2){ // right click: move an existing point, no matter what
//      const idx = nearestPointIndex(sx, sy);
//      if(idx >= 0){ pushHistory(); dragIndex = idx; }
//      return;
//    }
//
//    if(e.button === 0){ // left click: start of a click-or-drag draw gesture
//      const [wx,wy] = toWorld(sx,sy);
//      drawing = true;
//      drawStartWorld = [wx,wy];
//      drawStartScreen = [sx,sy];
//      previewEnd = [wx,wy];
//    }
//  });
//
//  canvas.addEventListener('mouseup', e=>{
//    if(panning){ panning = false; canvas.style.cursor = 'crosshair'; return; }
//    if(dragIndex >= 0){ dragIndex = -1; return; }
//
//    if(drawing){
//      const [sx,sy] = getMousePos(e);
//      const movedPx = Math.hypot(sx - drawStartScreen[0], sy - drawStartScreen[1]);
//      const [wx,wy] = toWorld(sx,sy);
//
//      pushHistory();
//      if(movedPx < CLICK_THRESHOLD_PX){
//        // plain click -> MOVE
//        commands.push({t:'MOVE', x: drawStartWorld[0], y: drawStartWorld[1]});
//      } else {
//        // drag -> LINE (auto-insert a MOVE first, unless continuing from the last point)
//        const last = commands.length ? commands[commands.length-1] : null;
//        const continuesPath = last && last.x === drawStartWorld[0] && last.y === drawStartWorld[1];
//        if(!continuesPath) commands.push({t:'MOVE', x: drawStartWorld[0], y: drawStartWorld[1]});
//        commands.push({t:'LINE', x: wx, y: wy});
//      }
//      drawing = false; drawStartWorld = null; previewEnd = null;
//      renderAll();
//    }
//  });
//  canvas.addEventListener('mouseleave', ()=>{
//    panning = false; dragIndex = -1; drawing = false; previewEnd = null;
//    canvas.style.cursor = 'crosshair';
//  });
//
//  canvas.addEventListener('wheel', e=>{
//    e.preventDefault();
//    const [sx,sy] = getMousePos(e);
//    const [wx,wy] = toWorld(sx, sy, false); // world point under cursor, unsnapped
//
//    const factor = Math.pow(1.0015, -e.deltaY); // smooth, ~infinite range
//    const newPx = Math.min(MAX_PX, Math.max(MIN_PX, px * factor));
//
//    // keep the point under the cursor fixed on screen while zooming
//    originX = sx - wx * newPx;
//    originY = sy - wy * newPx;
//    px = newPx;
//
//    updateZoomReadout();
//    draw();
//  }, { passive:false });
//
//  document.getElementById('resetViewBtn').addEventListener('click', ()=>{
//    px = 16; originX = 40; originY = 40;
//    updateZoomReadout();
//    draw();
//  });
//
//  document.getElementById('snapGrid').addEventListener('change', e=> snap = e.target.checked);
//  document.getElementById('showGrid').addEventListener('change', draw);
//  document.getElementById('undoBtn').addEventListener('click', undo);
//  document.getElementById('clearBtn').addEventListener('click', ()=>{
//    if(commands.length && !confirm('Clear all commands?')) return;
//    pushHistory(); commands = []; renderAll();
//  });
//
//  // --- tabs ---
//  document.querySelectorAll('.tab-btn').forEach(btn=>{
//    btn.addEventListener('click', ()=>{
//      document.querySelectorAll('.tab-btn').forEach(b=>b.classList.remove('active'));
//      document.querySelectorAll('.tabpane').forEach(p=>p.classList.remove('active'));
//      btn.classList.add('active');
//      document.getElementById('tab-'+btn.dataset.tab).classList.add('active');
//    });
//  });
//
//  // --- style panel ---
//  ['fillEnabled','fillColor','fillAlpha','strokeEnabled','strokeColor','strokeAlpha','strokeThickness','iconName'].forEach(id=>{
//    document.getElementById(id).addEventListener('input', ()=>{
//      document.getElementById('fillAlphaVal').textContent = parseFloat(document.getElementById('fillAlpha').value).toFixed(2);
//      document.getElementById('strokeAlphaVal').textContent = parseFloat(document.getElementById('strokeAlpha').value).toFixed(2);
//      syncHexFields();
//      renderAll();
//    });
//  });
//  function syncHexFields(){
//    document.getElementById('fillColorHex').value = colorInputToHaxeHex(document.getElementById('fillColor'));
//    document.getElementById('strokeColorHex').value = colorInputToHaxeHex(document.getElementById('strokeColor'));
//  }
//  document.getElementById('fillColorHex').addEventListener('change', e=>{
//    try{ document.getElementById('fillColor').value = '#' + e.target.value.replace('0x','').replace('0X','').padStart(6,'0'); renderAll(); }catch(err){}
//  });
//  document.getElementById('strokeColorHex').addEventListener('change', e=>{
//    try{ document.getElementById('strokeColor').value = '#' + e.target.value.replace('0x','').replace('0X','').padStart(6,'0'); renderAll(); }catch(err){}
//  });
//  syncHexFields();
//
//  // --- copy ---
//  document.getElementById('copyBtn').addEventListener('click', ()=>{
//    const ta = document.getElementById('exportCode');
//    ta.select();
//    try{ document.execCommand('copy'); }catch(e){}
//    if(navigator.clipboard) navigator.clipboard.writeText(ta.value).catch(()=>{});
//    const btn = document.getElementById('copyBtn');
//    const old = btn.textContent; btn.textContent = 'Copied!';
//    setTimeout(()=> btn.textContent = old, 1200);
//  });
//
//  // --- import parser ---
//  document.getElementById('importBtn').addEventListener('click', ()=>{
//    const raw = document.getElementById('importCode').value;
//    const msg = document.getElementById('importMsg');
//    try{
//      const re = /\{\s*t\s*:\s*(MOVE|LINE)\s*,\s*a\s*:\s*\{\s*x\s*:\s*(-?[\d.]+)\s*,\s*y\s*:\s*(-?[\d.]+)\s*\}\s*\}/g;
//      let m, parsed = [];
//      while((m = re.exec(raw)) !== null){
//        parsed.push({t:m[1], x:parseFloat(m[2]), y:parseFloat(m[3])});
//      }
//      if(!parsed.length){ msg.textContent = 'No commands found — check the format matches {t:MOVE, a:{x:.., y:..}}.'; msg.style.color = 'var(--danger)'; return; }
//      pushHistory();
//      commands = parsed;
//      renderAll();
//      msg.textContent = `Loaded ${parsed.length} command(s).`;
//      msg.style.color = 'var(--accent)';
//    }catch(err){
//      msg.textContent = 'Parse error: ' + err.message;
//      msg.style.color = 'var(--danger)';
//    }
//  });
//
//  // resize canvas to holder
//  function fitCanvas(){
//    const r = holder.getBoundingClientRect();
//    canvas.width = Math.max(600, r.width);
//    canvas.height = Math.max(500, r.height);
//    draw();
//  }
//  window.addEventListener('resize', fitCanvas);
//  setTimeout(fitCanvas, 50);
//
//  updateZoomReadout();
//  renderAll();
// })();
// </script>
// </body>
// </html>
//
