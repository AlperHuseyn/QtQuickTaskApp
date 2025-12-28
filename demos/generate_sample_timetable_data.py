#!/usr/bin/env python3
"""
Sample script to generate test data for the weekly timetable view.
This creates a JSON file with sample timetable tasks that can be used for testing.
"""

import json
from datetime import datetime, timedelta

def get_week_start():
    """Get the start of the current week (Sunday)"""
    today = datetime.now()
    # Calculate days until Sunday (0 = Monday in weekday())
    days_since_sunday = (today.weekday() + 1) % 7
    week_start = today - timedelta(days=days_since_sunday)
    week_start = week_start.replace(hour=0, minute=0, second=0, microsecond=0)
    return week_start

def create_sample_tasks():
    """Create sample timetable tasks"""
    week_start = get_week_start()
    
    tasks = []
    
    # Monday morning workout
    task_date = week_start + timedelta(days=1, hours=6)
    tasks.append({
        "title": "Morning Workout",
        "done": False,
        "day": 1,  # Monday
        "hour": 6,
        "taskType": "workout",
        "notes": "30 min cardio + strength training\nFocus on upper body",
        "dateTime": task_date.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    })
    
    # Monday work
    task_date = week_start + timedelta(days=1, hours=9)
    tasks.append({
        "title": "Sprint Planning",
        "done": False,
        "day": 1,
        "hour": 9,
        "taskType": "meeting",
        "notes": "Review backlog items\nPrioritize user stories",
        "dateTime": task_date.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    })
    
    # Tuesday workout
    task_date = week_start + timedelta(days=2, hours=18)
    tasks.append({
        "title": "Evening Run",
        "done": False,
        "day": 2,  # Tuesday
        "hour": 18,
        "taskType": "workout",
        "notes": "5K run\nMaintain 6 min/km pace",
        "dateTime": task_date.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    })
    
    # Wednesday work
    task_date = week_start + timedelta(days=3, hours=14)
    tasks.append({
        "title": "Code Review Session",
        "done": False,
        "day": 3,  # Wednesday
        "hour": 14,
        "taskType": "work",
        "notes": "Review PRs from team members\nProvide constructive feedback",
        "dateTime": task_date.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    })
    
    # Thursday morning meeting
    task_date = week_start + timedelta(days=4, hours=10)
    tasks.append({
        "title": "Team Standup",
        "done": False,
        "day": 4,  # Thursday
        "hour": 10,
        "taskType": "meeting",
        "notes": "Daily sync with the team",
        "dateTime": task_date.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    })
    
    # Thursday workout
    task_date = week_start + timedelta(days=4, hours=17)
    tasks.append({
        "title": "Gym Session",
        "done": False,
        "day": 4,
        "hour": 17,
        "taskType": "workout",
        "notes": "Lower body workout\nSquats, lunges, leg press",
        "dateTime": task_date.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    })
    
    # Friday work
    task_date = week_start + timedelta(days=5, hours=15)
    tasks.append({
        "title": "Sprint Review",
        "done": False,
        "day": 5,  # Friday
        "hour": 15,
        "taskType": "meeting",
        "notes": "Demo completed features\nGather feedback",
        "dateTime": task_date.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    })
    
    # Saturday personal
    task_date = week_start + timedelta(days=6, hours=10)
    tasks.append({
        "title": "Grocery Shopping",
        "done": False,
        "day": 6,  # Saturday
        "hour": 10,
        "taskType": "personal",
        "notes": "Weekly groceries\nDon't forget fruits and vegetables",
        "dateTime": task_date.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    })
    
    # Saturday workout
    task_date = week_start + timedelta(days=6, hours=8)
    tasks.append({
        "title": "Morning Yoga",
        "done": False,
        "day": 6,
        "hour": 8,
        "taskType": "workout",
        "notes": "1 hour yoga session\nFocus on flexibility and breathing",
        "dateTime": task_date.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    })
    
    # Sunday personal
    task_date = week_start + timedelta(days=0, hours=12)
    tasks.append({
        "title": "Meal Prep",
        "done": False,
        "day": 0,  # Sunday
        "hour": 12,
        "taskType": "personal",
        "notes": "Prepare meals for the week\nHealthy, balanced options",
        "dateTime": task_date.strftime("%Y-%m-%dT%H:%M:%S.000Z")
    })
    
    # Add a few simple tasks (old format) for backward compatibility testing
    tasks.append({
        "title": "Review Qt documentation",
        "done": False,
        "day": -1,
        "hour": -1,
        "taskType": "other",
        "notes": ""
    })
    
    tasks.append({
        "title": "Update project README",
        "done": False,
        "day": -1,
        "hour": -1,
        "taskType": "other",
        "notes": ""
    })
    
    return {"tasks": tasks}

def main():
    """Generate and save sample tasks"""
    sample_data = create_sample_tasks()
    
    # Save to file
    output_file = "sample_tasks.json"
    with open(output_file, 'w') as f:
        json.dump(sample_data, f, indent=2)
    
    print(f"Sample tasks generated and saved to {output_file}")
    print(f"Total tasks: {len(sample_data['tasks'])}")
    print(f"Timetable tasks: {sum(1 for t in sample_data['tasks'] if t['day'] >= 0)}")
    print(f"Simple tasks: {sum(1 for t in sample_data['tasks'] if t['day'] < 0)}")

if __name__ == "__main__":
    main()
