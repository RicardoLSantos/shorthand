RuleSet: MindfulnessObservationNarrative
* text.status = #generated
* text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">
    <p><b>Generated Narrative</b></p>
    <p><b>Session Type:</b> Mindfulness Practice Session</p>
    <p><b>Date:</b> {effectiveDateTime}</p>
    <p><b>Duration:</b> {component[sessionDuration].value} minutes</p>
    <p><b>Stress Level:</b> {component[stressLevel].value} / 10</p>
    <p><b>Mood:</b> {component[moodState].value}</p>
    <p><b>Technique:</b> {component[relaxationResponse].value}</p>
    <p><b>Location:</b> {extension[mindfulness-context].extension[location].value}</p>
  </div>"

RuleSet: MindfulnessQuestionnaireNarrative
* text.status = #generated
* text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">
    <p><b>Generated Narrative</b></p>
    <p><b>Title:</b> {title}</p>
    <p><b>Status:</b> {status}</p>
    <h3>Sections</h3>
    <ul>
      <li>Mindfulness Session</li>
      <li>Mood Assessment</li>
      <li>Stress Assessment</li>
      <li>Relaxation</li>
    </ul>
  </div>"

RuleSet: MindfulnessResponseNarrative
* text.status = #generated
* text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">
    <p><b>Generated Narrative</b></p>
    <p><b>Date:</b> {authored}</p>
    <p><b>Session Duration:</b> {item[session_duration].answer.value} minutes</p>
    <p><b>Practice Type:</b> {item[practice_type].answer.value}</p>
    <p><b>Mood:</b> {item[current_mood].answer.value}</p>
    <p><b>Stress Level:</b> {item[stress_level].answer.value} / 10</p>
    <p><b>Relaxation Technique:</b> {item[relaxation_technique].answer.value}</p>
  </div>"

RuleSet: MindfulnessConfigNarrative
* text.status = #generated
* text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">
    <p><b>Generated Narrative</b></p>
    <p><b>Default Duration:</b> {extension[defaultDuration].value} minutes</p>
    <p><b>Reminders:</b> {extension[reminderSettings].value}</p>
    <p><b>Data Sync:</b> {extension[dataSync].value}</p>
  </div>"
