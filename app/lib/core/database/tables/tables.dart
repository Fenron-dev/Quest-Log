import 'package:drift/drift.dart';

import 'enums.dart';
import 'sync_columns.dart';

class Workspaces extends Table with SyncColumns {
  TextColumn get name => text()();
}

class Customers extends Table with SyncColumns {
  TextColumn get name => text()();
  IntColumn get color => integer().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get itflowClientId => integer().nullable()();
  IntColumn get contingentAePerMonth => integer().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}

class Contacts extends Table with SyncColumns {
  TextColumn get customerId => text().references(Customers, #id)();
  TextColumn get name => text()();
  TextColumn get role => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
}

class Projects extends Table with SyncColumns {
  /// Null means an internal project.
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  TextColumn get name => text()();

  /// Null means the colour is inherited from the customer.
  IntColumn get color => integer().nullable()();
  TextColumn get status => textEnum<ProjectStatus>().withDefault(
    Constant(ProjectStatus.planned.name),
  )();
  DateTimeColumn get start => dateTime().nullable()();
  DateTimeColumn get due => dateTime().nullable()();
  IntColumn get budgetAe => integer().nullable()();
  IntColumn get warnPercent => integer().withDefault(const Constant(80))();
  IntColumn get itflowProjectId => integer().nullable()();
}

class Milestones extends Table with SyncColumns {
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get title => text()();
  IntColumn get order => integer().withDefault(const Constant(0))();
  TextColumn get status => textEnum<MilestoneStatus>().withDefault(
    Constant(MilestoneStatus.open.name),
  )();
}

@DataClassName('Criterion')
class Criteria extends Table with SyncColumns {
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get label => text()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
}

class Goals extends Table with SyncColumns {
  TextColumn get title => text()();
  TextColumn get area => text().nullable()();
  IntColumn get weeklyInputTarget => integer().nullable()();
  TextColumn get status =>
      textEnum<GoalStatus>().withDefault(Constant(GoalStatus.active.name))();
}

class Habits extends Table with SyncColumns {
  TextColumn get title => text()();
  IntColumn get timesPerWeek => integer().withDefault(const Constant(1))();
}

class Templates extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get titlePattern => text()();

  /// JSON-encoded list of capture field definitions.
  TextColumn get fields => text().nullable()();

  /// JSON-encoded ordered checklist definition.
  TextColumn get checklist => text().nullable()();
  TextColumn get defaultCustomerId =>
      text().nullable().references(Customers, #id)();
  IntColumn get estimate => integer().nullable()();
  IntColumn get flatRateAe => integer().nullable()();
  IntColumn get targetMinutes => integer().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}

class Tasks extends Table with SyncColumns {
  TextColumn get title => text()();
  TextColumn get status =>
      textEnum<TaskStatus>().withDefault(Constant(TaskStatus.inbox.name))();
  DateTimeColumn get plannedDay => dateTime().nullable()();
  IntColumn get order => integer().withDefault(const Constant(0))();
  DateTimeColumn get due => dateTime().nullable()();
  BoolColumn get important => boolean().withDefault(const Constant(false))();
  IntColumn get estimateMin => integer().nullable()();
  TextColumn get source => textEnum<TaskSource>().nullable()();
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  TextColumn get projectId => text().nullable().references(Projects, #id)();
  TextColumn get milestoneId => text().nullable().references(Milestones, #id)();
  TextColumn get goalId => text().nullable().references(Goals, #id)();
  TextColumn get templateId => text().nullable().references(Templates, #id)();
  IntColumn get itflowTicketId => integer().nullable()();
  TextColumn get waitingFor => text().nullable()();
  DateTimeColumn get waitingSince => dateTime().nullable()();
  DateTimeColumn get followUpDate => dateTime().nullable()();

  /// Recurrence rule, stored as text.
  TextColumn get recurrence => text().nullable()();

  /// JSON-encoded list of tags.
  TextColumn get tags => text().nullable()();
}

class ChecklistItems extends Table with SyncColumns {
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get label => text()();
  IntColumn get order => integer().withDefault(const Constant(0))();
  BoolColumn get required => boolean().withDefault(const Constant(false))();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  DateTimeColumn get doneAt => dateTime().nullable()();
}

class TimeEntries extends Table with SyncColumns {
  DateTimeColumn get start => dateTime()();

  /// Null while the timer is still running.
  DateTimeColumn get end => dateTime().nullable()();
  TextColumn get kind => textEnum<TimeEntryKind>().withDefault(
    Constant(TimeEntryKind.active.name),
  )();
  TextColumn get category => text().nullable()();
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  TextColumn get taskId => text().nullable().references(Tasks, #id)();
  TextColumn get projectId => text().nullable().references(Projects, #id)();
  TextColumn get goalId => text().nullable().references(Goals, #id)();
  BoolColumn get billable => boolean().withDefault(const Constant(true))();
  TextColumn get note => text().nullable()();
  IntColumn get ticketId => integer().nullable()();
  BoolColumn get syncedToItflow =>
      boolean().withDefault(const Constant(false))();
}

class TimeEntryColleagues extends Table with SyncColumns {
  TextColumn get timeEntryId => text().references(TimeEntries, #id)();
  TextColumn get colleagueName => text()();
  IntColumn get minutes => integer()();
}

class WorkClocks extends Table with SyncColumns {
  DateTimeColumn get day => dateTime()();
  DateTimeColumn get start => dateTime()();

  /// JSON-encoded list of pause intervals.
  TextColumn get pauses => text().nullable()();
  DateTimeColumn get end => dateTime().nullable()();
}

class Notes extends Table with SyncColumns {
  TextColumn get parentType => textEnum<NoteParentType>()();
  TextColumn get parentId => text()();
  TextColumn get type =>
      textEnum<NoteType>().withDefault(Constant(NoteType.text.name))();
  TextColumn get body => text().nullable()();
  TextColumn get mediaPath => text().nullable()();
  TextColumn get transcript => text().nullable()();
  BoolColumn get isSolution => boolean().withDefault(const Constant(false))();
}

@DataClassName('MaterialItem')
class Materials extends Table with SyncColumns {
  TextColumn get taskId => text().references(Tasks, #id)();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get ean => text().nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get note => text().nullable()();
}

class CheckRounds extends Table with SyncColumns {
  TextColumn get name => text()();
  IntColumn get weekday => integer()();
  TextColumn get templateId => text().nullable().references(Templates, #id)();
}

class CheckRoundResults extends Table with SyncColumns {
  TextColumn get checkRoundId => text().references(CheckRounds, #id)();
  TextColumn get customerId => text().references(Customers, #id)();
  TextColumn get result => textEnum<CheckResult>()();
  TextColumn get note => text().nullable()();
}
