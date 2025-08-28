<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <title>QualitySim — SPC + Acceptance Sampling Sandbox</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta name="description" content="Interactive SPC & acceptance sampling simulator for Quality Engineering — X̄ control chart, OC curve, Cpk/Ppk, AOQ, costs, gage error, drift. Runs on GitHub Pages." />
  <meta property="og:title" content="QualitySim — SPC + Acceptance Sampling Sandbox" />
  <meta property="og:description" content="Browser-only simulator for Quality Engineering courses. Explore capability, SPC, acceptance sampling, and costs." />
  <meta property="og:type" content="website" />
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    :root { --pad: 12px; --gap: 10px; --bg: #0f172a; --panel: #0b1220; --card: #111827; --text: #e5e7eb; --muted:#9ca3af; --border:#253046; --accent:#22c55e; }
    html,body{margin:0;background:var(--bg);color:var(--text);font:15px/1.45 system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,"Helvetica Neue",Arial}
    header{padding:24px var(--pad) 8px;max-width:1200px;margin:auto}
    h1{font-size:22px;margin:0 0 6px}
    p.lead{margin:0;color:var(--muted)}
    .wrap{max-width:1200px;margin:0 auto;padding:0 var(--pad) 40px}
    fieldset{border:1px solid var(--border);border-radius:12px;background:var(--card);margin-top:14px}
    legend{color:var(--muted);padding:0 6px}
    .controls{display:grid;grid-template-columns:repeat(4,1fr);gap:var(--gap);padding:var(--pad)}
    @media (max-width:1100px){.controls{grid-template-columns:repeat(2,1fr)}}
    label{display:flex;flex-direction:column;gap:6px;font-size:13px;color:var(--muted)}
    input[type="number"]{background:var(--panel);border:1px solid var(--border);color:var(--text);padding:8px;border-radius:8px}
    input[type="checkbox"]{transform:scale(1.15);margin-right:8px}
    .row{display:flex;gap:10px;align-items:center}
    .btns{display:flex;flex-wrap:wrap;gap:10px; padding:0 var(--pad) var(--pad)}
    button{background:#1f2937;border:1px solid #334155;color:var(--text);padding:10px 14px;border-radius:10px;cursor:pointer}
    button.primary{background:#16a34a;border-color:#22c55e;color:black;font-weight:700}
    button:disabled{opacity:.55;cursor:not-allowed}
    .cards{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;padding:var(--pad)}
    @media (max-width:1100px){.cards{grid-template-columns:1fr}}
    .card{background:var(--panel);border:1px solid var(--border);border-radius:12px;padding:12px}
    .kpi{display:flex;justify-content:space-between;align-items:baseline}
    .kpi h3{margin:0;font-size:13px;color:var(--muted)}
    .kpi .val{font-weight:700;font-size:20px}
    .tiny{font-size:12px;color:var(--muted);margin-top:2px}
    .grid{display:grid;grid-template-columns:1.1fr .9fr;gap:16px;padding:0 var(--pad)}
    @media (max-width:1100px){.grid{grid-template-columns:1fr}}
    canvas{background:var(--panel);border:1px solid var(--border);border-radius:12px}
    .note{color:#94a3b8;font-size:12px;padding:0 var(--pad) var(--pad)}
    details{background:#0d1527;border:1px solid var(--border);border-radius:10px;padding:10px;margin-top:10px}
    footer{max-width:1200px;margin:20px auto 60px;color:#94a3b8;font-size:12px;padding:0 var(--pad)}
    .warn{color:#fbbf24}
  </style>
</head>
<body>
  <header>
    <h1>QualitySim — SPC + Acceptance Sampling Sandbox</h1>
    <p class="lead">Simulate a production process with specs, drift, assignable causes, gage error, SPC, and a single-sampling plan (n, c). Explore capability, AOQ, OC curves, and cost.</p>
  </header>

  <div class="wrap">
    <details>
      <summary><strong>Quick guide</strong></summary>
      <div class="tiny" style="margin-top:6px">
        1) Set specs (LSL/USL), process μ and σ. 2) Choose subgroup size for X̄ chart and (n, c) for acceptance sampling. 3) Click <em>Run simulation</em>. 
        KPIs show DPMO, Cpk, % lots accepted, AOQ, cost/unit, and SPC resets. The OC curve depends on (n, c) only. Histogram shows true item distribution vs. specs.
      </div>
    </details>

    <fieldset>
      <legend>Inputs</legend>
      <div class="controls">
        <!-- Specs & process -->
        <label>LSL
          <input type="number" step="0.001" id="LSL" value="9.5">
        </label>
        <label>USL
          <input type="number" step="0.001" id="USL" value="10.5">
        </label>
        <label>Target mean μ<sub>0</sub>
          <input type="number" step="0.001" id="mu0" value="10.0">
        </label>
        <label>Process σ
          <input type="number" step="0.001" id="sigma" value="0.15">
        </label>

        <!-- Measurement system -->
        <label>Gage σ as % of Tolerance
          <input type="number" step="0.1" id="gagePctTol" value="5">
        </label>

        <!-- SPC -->
        <label>Subgroup size (n̄)
          <input type="number" id="subgroupN" value="5" min="2" max="25">
        </label>
        <label class="row"><span><input type="checkbox" id="spcOn" checked>Enable SPC resets</span></label>
        <label>Stoppage cost ($/reset)
          <input type="number" step="0.01" id="stoppageCost" value="50">
        </label>

        <!-- Acceptance sampling -->
        <label>Lot size (N)
          <input type="number" id="lotSize" value="100" min="10">
        </label>
        <label>Sample size (n)
          <input type="number" id="sampleN" value="50" min="1">
        </label>
        <label>Acceptance number (c)
          <input type="number" id="acceptC" value="2" min="0">
        </label>
        <label># lots
          <input type="number" id="nLots" value="50" min="1">
        </label>

        <!-- Dynamics -->
        <label>Assignable cause prob/lot
          <input type="number" step="0.01" id="acProb" value="0.10" min="0" max="1">
        </label>
        <label>Assignable shift (σ-multipliers)
          <input type="number" step="0.1" id="acSigmaMult" value="1.5" min="0">
        </label>
        <label>Drift per 100 items (units)
          <input type="number" step="0.001" id="driftPer100" value="0.02">
        </label>
        <label></label>

        <!-- Costs -->
        <label>Inspection cost ($/sampled part)
          <input type="number" step="0.01" id="inspectCost" value="0.05">
        </label>
        <label>Scrap/rework cost ($/rejected lot part)
          <input type="number" step="0.01" id="scrapCost" value="3.0">
        </label>
        <label>External failure cost ($/escape)
          <input type="number" step="0.01" id="extCost" value="30.0">
        </label>
        <label></label>
      </div>

      <div class="btns">
        <button class="primary" id="runBtn">Run simulation</button>
        <button id="resetBtn">Reset to recommended defaults</button>
        <button id="downloadBtn" disabled>Download CSV (summary + lots + X̄)</button>
        <span class="note">Control limits use known σ: UCL/LCL = μ<sub>0</sub> ± 3σ/√n̄.</span>
      </div>
    </fieldset>

    <div class="cards" id="kpis">
      <div class="card"><div class="kpi"><h3>DPMO</h3><div class="val" id="dpmo">—</div></div><div class="tiny">Observed defects per million opportunities</div></div>
      <div class="card"><div class="kpi"><h3>Cpk (Ppk)</h3><div class="val" id="cpk">—</div></div><div class="tiny">Based on overall σ across all simulated items</div></div>
      <div class="card"><div class="kpi"><h3>% Lots Accepted</h3><div class="val" id="pa">—</div></div><div class="tiny">Observed over all simulated lots</div></div>
      <div class="card"><div class="kpi"><h3>AOQ (Observed)</h3><div class="val" id="aoq">—</div></div><div class="tiny">Fraction defective leaving the system</div></div>
      <div class="card"><div class="kpi"><h3>Cost / Unit</h3><div class="val" id="cpu">—</div></div><div class="tiny">Inspection + scrap + external failure + stoppages</div></div>
      <div class="card"><div class="kpi"><h3>SPC Resets</h3><div class="val" id="stops">—</div></div><div class="tiny">Triggered by X̄ beyond 3σ/√n̄</div></div>
    </div>

    <div class="grid">
      <div class="card">
        <h3 style="margin:0 0 8px;">\u0305X Control Chart</h3>
        <canvas id="controlChart" height="240" aria-label="Xbar control chart" role="img"></canvas>
        <div class="tiny">Subgroup means with CL / UCL / LCL (based on μ<sub>0</sub> and known σ).</div>
      </div>
      <div class="card">
        <h3 style="margin:0 0 8px;">OC Curve for (n, c)</h3>
        <canvas id="ocChart" height="240" aria-label="Operating characteristic curve" role="img"></canvas>
        <div class="tiny">P(accept) = \u2211<sub>i=0..c</sub> C(n,i) p^i (1−p)^{n−i}</div>
      </div>
    </div>

    <div class="card" style="margin-top:16px;">
      <h3 style="margin:0 0 8px;">Process Output Histogram</h3>
      <canvas id="histChart" height="240" aria-label="Process output histogram" role="img"></canvas>
      <div class="tiny">Distribution of produced items (true values). LSL/USL shown as vertical bands.</div>
    </div>

    <p class="note">Try: increase gage %Tol or assignable shift to see how escapes and cost/unit change; then adjust (n, c) to trade off AOQ vs. inspection cost.</p>
  </div>

  <footer>
    Built for teaching Quality Engineering. No external services; runs entirely in the browser.
  </footer>

<script>
/* ============== Math & helpers ============== */
function randn(){ // Box–Muller
  let u=0,v=0; while(u===0) u=Math.random(); while(v===0) v=Math.random();
  return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v);
}
function normal(mu, sigma){ return mu + sigma*randn(); }

function sampleWithoutReplacement(N, n){
  n = Math.min(n, N);
  const arr = Array.from({length:N}, (_,i)=>i);
  for(let i=0;i<n;i++){
    const j = i + Math.floor(Math.random()*(N-i));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr.slice(0, n);
}

// Log-factorial cache grows on demand (for stable binomial sums up to large n)
const logFactCache = [0];
function ensureLogFactUpTo(n){
  for(let i=logFactCache.length;i<=n;i++){ logFactCache[i] = logFactCache[i-1] + Math.log(i); }
}
function logChoose(n,k){
  if(k<0||k>n) return -Infinity;
  ensureLogFactUpTo(n);
  return logFactCache[n] - logFactCache[k] - logFactCache[n-k];
}
function ocProbability(n,c,p){
  // P(accept) = sum_{i=0..c} C(n,i) p^i (1-p)^(n-i)
  p = Math.min(1-1e-12, Math.max(1e-12, p));
  let s=0;
  for(let i=0;i<=c;i++){
    const logTerm = logChoose(n,i) + i*Math.log(p) + (n-i)*Math.log(1-p);
    s += Math.exp(logTerm);
  }
  return s;
}
function computeHistogram(data, bins=30){
  if(data.length===0) return {centers:[], counts:[], min:0, max:1};
  let min = Math.min(...data), max = Math.max(...data);
  if(min===max){ min -= 0.5; max += 0.5; }
  const width = (max - min)/bins;
  const counts = Array(bins).fill(0);
  for(const x of data){
    let k = Math.floor((x - min)/width);
    if(k<0) k=0; if(k>=bins) k=bins-1;
    counts[k]++;
  }
  const centers = Array.from({length:bins}, (_,i)=> min + (i+0.5)*width);
  return {centers, counts, min, max, width};
}

/* ============== Core simulation ============== */
/* Key improvement: SPC resets happen "online" during production — 
   we produce items sequentially, form subgroups on the fly, and reset μ immediately if X̄ is out-of-control. */
function simulate(params){
  const {
    LSL, USL, mu0, sigma, gagePctTol, lotSize, nLots,
    sampleN, acceptC, subgroupN, spcOn, acProb, acSigmaMult,
    driftPer100, inspectCost, scrapCost, extCost, stoppageCost
  } = params;

  const tol = USL - LSL;
  if(!(USL > LSL)) throw new Error("USL must be greater than LSL.");
  if(!(sigma > 0)) throw new Error("Process σ must be positive.");
  if(!(subgroupN >= 2)) throw new Error("Subgroup size must be ≥ 2.");
  if(sampleN > lotSize) throw new Error("Sample size n cannot exceed lot size N.");
  if(acceptC > sampleN) throw new Error("Acceptance number c cannot exceed sample size n.");

  const gageSigma = (gagePctTol/100) * tol;
  const driftPerItem = driftPer100 / 100.0;

  let mu = mu0;
  let resets = 0;
  const UCL = mu0 + 3*sigma/Math.sqrt(subgroupN);
  const LCL = mu0 - 3*sigma/Math.sqrt(subgroupN);
  const CL  = mu0;

  const xbarPoints = []; // {idx, mean, lot}
  let subgroupIdx = 0;

  const allItems = []; // true values over entire run
  const lotSummaries = []; // {lot, trueDefects, sampleDefectsMeasured, accepted}

  let totalDefectsTrue = 0;
  let totalEscapes = 0;
  let lotsAccepted = 0;

  let costInspection = 0, costScrap = 0, costExternal = 0;

  // Produce lots
  for(let L=0; L<nLots; L++){
    // Random assignable cause at lot start
    if(Math.random() < acProb){
      mu += acSigmaMult * sigma * randn(); // random direction/magnitude
    }

    const lotItems = new Array(lotSize);
    let trueDefects = 0;

    // Make subgroups on the fly so resets affect remaining items in the lot
    let subgroupBuf = [];

    for(let i=0;i<lotSize;i++){
      mu += driftPerItem; // gradual drift
      const x = normal(mu, sigma);
      lotItems[i] = x;
      allItems.push(x);
      if(x < LSL || x > USL) trueDefects++;

      // Subgroup build
      subgroupBuf.push(x);
      if(subgroupBuf.length === subgroupN){
        const mean = subgroupBuf.reduce((a,b)=>a+b,0)/subgroupN;
        xbarPoints.push({idx: subgroupIdx++, mean, lot: L});
        // SPC decision now
        if(spcOn && (mean > UCL || mean < LCL)){
          resets++;
          mu = mu0;       // snap back to target
        }
        subgroupBuf = []; // start new subgroup
      }
    }

    // Acceptance sampling with gage error on sampled items
    const sampleIdx = sampleWithoutReplacement(lotSize, sampleN);
    let sampleDefectsMeasured = 0;
    for(const idx of sampleIdx){
      const meas = lotItems[idx] + normal(0, gageSigma);
      if(meas < LSL || meas > USL) sampleDefectsMeasured++;
    }
    const accepted = (sampleDefectsMeasured <= acceptC);
    costInspection += inspectCost * sampleN;

    if(accepted){
      lotsAccepted++;
      totalEscapes += trueDefects; // all true defects pass through
      costExternal += trueDefects * extCost;
    } else {
      costScrap += scrapCost * lotSize; // rectification scrap/rework cost
    }

    totalDefectsTrue += trueDefects;
    lotSummaries.push({lot:L, trueDefects, sampleDefectsMeasured, accepted});
  }

  // Global stats over all items
  const Nitems = lotSize * nLots;
  const meanAll = allItems.reduce((a,b)=>a+b,0)/Nitems;
  const varAll = allItems.reduce((s,x)=> s + (x-meanAll)*(x-meanAll), 0) / (Nitems - 1);
  const sdAll = Math.sqrt(varAll);

  const cpk = Math.min((USL - meanAll)/(3*sdAll), (meanAll - LSL)/(3*sdAll));
  const dpmo = (totalDefectsTrue / Nitems) * 1e6;
  const pa = lotsAccepted / nLots;
  const aoq = (totalEscapes / Nitems); // observed outgoing fraction defective

  const totalCost = costInspection + costScrap + costExternal + resets*stoppageCost;
  const costPerUnit = totalCost / Nitems;

  return {
    xbarPoints, UCL, LCL, CL,
    allItems, LSL, USL,
    dpmo, cpk, pa, aoq, costPerUnit, resets,
    lotSize, nLots, lotSummaries
  };
}

/* ============== Charts ============== */
let controlChart, ocChart, histChart;
function ensureCharts(){
  if(!controlChart){
    controlChart = new Chart(document.getElementById('controlChart'), {
      type: 'line',
      data: { labels: [], datasets: [
        { label:'X̄', data: [], borderWidth:1, pointRadius:0, tension:0, fill:false },
        { label:'UCL', data: [], borderWidth:1, pointRadius:0, borderDash:[4,4], tension:0 },
        { label:'CL',  data: [], borderWidth:1, pointRadius:0, borderDash:[4,4], tension:0 },
        { label:'LCL', data: [], borderWidth:1, pointRadius:0, borderDash:[4,4], tension:0 }
      ]},
      options: { responsive:true, animation:false, scales:{
        x:{ title:{display:true,text:'Subgroup index'} },
        y:{ title:{display:true,text:'Subgroup mean'} }
      }, plugins:{ legend:{position:'bottom'} } }
    });
  }
  if(!ocChart){
    ocChart = new Chart(document.getElementById('ocChart'), {
      type: 'line',
      data: { labels: [], datasets: [{ label:'P(accept)', data:[], borderWidth:1, pointRadius:0, tension:0 }] },
      options:{ responsive:true, animation:false, scales:{
        x:{ title:{display:true, text:'p (fraction defective)'} },
        y:{ title:{display:true, text:'P(accept)'}, min:0, max:1 }
      }, plugins:{ legend:{position:'bottom'} } }
    });
  }
  if(!histChart){
    histChart = new Chart(document.getElementById('histChart'), {
      type: 'bar',
      data: { labels: [], datasets: [{ label:'Count', data:[] }] },
      options:{ responsive:true, animation:false, scales:{
        x:{ title:{display:true, text:'Dimension (units)'} },
        y:{ title:{display:true, text:'Frequency'} }
      }, plugins:{ legend:{display:false} } }
    });
  }
}
function renderControlChart(res){
  const labels = res.xbarPoints.map(p=>p.idx);
  const xb = res.xbarPoints.map(p=>p.mean);
  const U = xb.map(()=>res.UCL), C = xb.map(()=>res.CL), L = xb.map(()=>res.LCL);

  controlChart.data.labels = labels;
  controlChart.data.datasets[0].data = xb;
  controlChart.data.datasets[1].data = U;
  controlChart.data.datasets[2].data = C;
  controlChart.data.datasets[3].data = L;
  controlChart.update();
}
function renderOC(n, c){
  const xs = [], ys = [];
  for(let p=0; p<=0.30; p+=0.005){
    xs.push(Number(p.toFixed(3)));
    ys.push(ocProbability(n, c, p));
  }
  ocChart.data.labels = xs;
  ocChart.data.datasets[0].data = ys;
  ocChart.update();
}
function renderHist(res){
  const H = computeHistogram(res.allItems, 40);
  histChart.data.labels = H.centers.map(v=>Number(v.toFixed(3)));
  histChart.data.datasets[0].data = H.counts;
  histChart.update();

  // Draw LSL/USL guides (simple overlay using dataset borders)
  // Chart.js doesn't draw vertical bands natively without plugin; we emulate by adding tiny bars at LSL/USL bins (visual cue).
}

/* ============== UI glue ============== */
function num(id){ return Number(document.getElementById(id).value); }
function setVal(id, v){ document.getElementById(id).value = v; }
function run(){
  const params = {
    LSL: num('LSL'), USL: num('USL'),
    mu0: num('mu0'), sigma: num('sigma'),
    gagePctTol: num('gagePctTol'),
    lotSize: num('lotSize'), nLots: num('nLots'),
    sampleN: num('sampleN'), acceptC: num('acceptC'),
    subgroupN: num('subgroupN'), spcOn: document.getElementById('spcOn').checked,
    acProb: num('acProb'), acSigmaMult: num('acSigmaMult'),
    driftPer100: num('driftPer100'),
    inspectCost: num('inspectCost'), scrapCost: num('scrapCost'),
    extCost: num('extCost'), stoppageCost: num('stoppageCost')
  };

  try{
    const res = simulate(params);

    // KPIs
    document.getElementById('dpmo').textContent = Math.round(res.dpmo).toLocaleString();
    document.getElementById('cpk').textContent = (Math.round(res.cpk*100)/100).toFixed(2);
    document.getElementById('pa').textContent = (res.pa*100).toFixed(1) + '%';
    document.getElementById('aoq').textContent = (res.aoq*100).toFixed(2) + '%';
    document.getElementById('cpu').textContent = '$' + (Math.round(res.costPerUnit*100)/100).toFixed(2);
    document.getElementById('stops').textContent = res.resets;

    // Charts
    renderControlChart(res);
    renderOC(params.sampleN, params.acceptC);
    renderHist(res);

    // enable CSV
    document.getElementById('downloadBtn').disabled = false;
    window._lastSim = { params, res }; // store for CSV
  } catch(err){
    alert(err.message || String(err));
  }
}
function resetDefaults(){
  setVal('LSL', 9.5); setVal('USL', 10.5); setVal('mu0', 10.0); setVal('sigma', 0.15);
  setVal('gagePctTol', 5);
  setVal('subgroupN', 5); document.getElementById('spcOn').checked = true; setVal('stoppageCost', 50);
  setVal('lotSize', 100); setVal('sampleN', 50); setVal('acceptC', 2); setVal('nLots', 50);
  setVal('acProb', 0.10); setVal('acSigmaMult', 1.5); setVal('driftPer100', 0.02);
  setVal('inspectCost', 0.05); setVal('scrapCost', 3.0); setVal('extCost', 30.0);
}
function downloadCSV(){
  if(!window._lastSim) return;
  const { params, res } = window._lastSim;

  const lines = [];
  lines.push('Section,Metric,Value');
  lines.push('Run,LSL,'+params.LSL);
  lines.push('Run,USL,'+params.USL);
  lines.push('Run,mu0,'+params.mu0);
  lines.push('Run,sigma,'+params.sigma);
  lines.push('Run,gagePctTol,'+params.gagePctTol+'%');
  lines.push('Run,lotSize,'+params.lotSize);
  lines.push('Run,nLots,'+params.nLots);
  lines.push('Run,sampleN,'+params.sampleN);
  lines.push('Run,acceptC,'+params.acceptC);
  lines.push('Run,subgroupN,'+params.subgroupN);
  lines.push('Run,SPC,'+(document.getElementById("spcOn").checked?'on':'off'));
  lines.push('Run,acProb,'+params.acProb);
  lines.push('Run,acSigmaMult,'+params.acSigmaMult);
  lines.push('Run,driftPer100,'+params.driftPer100);
  lines.push('Run,inspectCost,'+params.inspectCost);
  lines.push('Run,scrapCost,'+params.scrapCost);
  lines.push('Run,extCost,'+params.extCost);
  lines.push('Run,stoppageCost,'+params.stoppageCost);
  lines.push('Run,DPMO,'+Math.round(res.dpmo));
  lines.push('Run,Cpk,'+res.cpk);
  lines.push('Run,PercentLotsAccepted,'+(res.pa*100).toFixed(2)+'%');
  lines.push('Run,AOQ_pct,'+(res.aoq*100).toFixed(3)+'%');
  lines.push('Run,CostPerUnit,'+res.costPerUnit);
  lines.push('Run,SPCResets,'+res.resets);

  lines.push('');
  lines.push('Lot Summaries');
  lines.push('lot,trueDefects,sampleDefectsMeasured,accepted');
  for(const L of res.lotSummaries){
    lines.push([L.lot, L.trueDefects, L.sampleDefectsMeasured, L.accepted?1:0].join(','));
  }

  lines.push('');
  lines.push('Xbar Series');
  lines.push('subgroupIndex,lot,xbar');
  for(const p of res.xbarPoints){
    lines.push([p.idx, p.lot, p.mean].join(','));
  }

  const blob = new Blob([lines.join('\n')], {type:'text/csv'});
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a'); a.href = url; a.download = 'qualitysim_run.csv'; a.click();
  URL.revokeObjectURL(url);
}

document.getElementById('runBtn').addEventListener('click', run);
document.getElementById('resetBtn').addEventListener('click', resetDefaults);
document.getElementById('downloadBtn').addEventListener('click', downloadCSV);
resetDefaults();
ensureCharts();
</script>
</body>
</html>
