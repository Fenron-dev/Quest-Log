enum ProjectStatus { planned, active, paused, fulfilled, cancelled }

enum MilestoneStatus { open, done }

enum GoalStatus { active, achieved, dropped }

enum TaskStatus {
  inbox,
  planned,
  inProgress,
  waitingFor,
  blocked,
  someday,
  done,
  dropped,
}

enum TaskSource { mail, phone, verbal, self }

enum TimeEntryKind { active, background }

enum NoteParentType { task, project, customer }

enum NoteType { text, voice, photo, video, screenshot, file }

enum CheckResult { ok, warning, error }
