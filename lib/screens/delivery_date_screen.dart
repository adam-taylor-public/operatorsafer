import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:operatorsafe/screens/delivery_api_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class DeliveryDateScreen extends StatefulWidget {
  const DeliveryDateScreen({super.key});

  @override
  State<DeliveryDateScreen> createState() => _DeliveryDateScreenState();
}

class _DeliveryDateScreenState extends State<DeliveryDateScreen> {
  // ─────────────────────────────────────────────────────────────
  // SECTION: State Variables
  // ─────────────────────────────────────────────────────────────
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final DateFormat dateFormatter = DateFormat('EEEE, dd MMMM yyyy');

  // ─────────────────────────────────────────────────────────────
  // SECTION: UI - Summary Card with Time Picker & Calendar
  // ─────────────────────────────────────────────────────────────
  Widget buildSummaryCard() {
    final dateStr = dateFormatter.format(selectedDate);
    final timeStr = selectedTime.format(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────────────────────
            // SUBSECTION: Time Picker Header & Button
            // ─────────────────────────────────────────────────────────
            const Text(
              "Delivery Time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeStr, // Display the selected time
                  style: const TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    final TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (newTime != null) {
                      setState(() {
                        selectedTime = newTime;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ─────────────────────────────────────────────────────────
            // SUBSECTION: Calendar Widget
            // ─────────────────────────────────────────────────────────
            TableCalendar(
              focusedDay: selectedDate,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.now(), // Restrict selection to today
              selectedDayPredicate: (day) {
                // Highlight selected date
                return isSameDay(selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  selectedDate = selectedDay; // Update selected date
                });
              },
              calendarStyle: CalendarStyle(
                todayTextStyle: const TextStyle(
                  color: Colors.black,
                ), // Today text color
                todayDecoration: BoxDecoration(
                  // Conditional decoration for today
                  color:
                      selectedDate.day == DateTime.now().day &&
                              selectedDate.month == DateTime.now().month &&
                              selectedDate.year == DateTime.now().year
                          ? Colors.blue
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(color: Colors.white),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION: Navigation - Proceed to Next Screen
  // ─────────────────────────────────────────────────────────────
  void _proceed() {
    final now = DateTime.now();
    final combinedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (combinedDateTime.isAfter(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You cannot select a future time')),
      );
      return;
    }

    print("Confirmed Delivery Time: $combinedDateTime");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DeliveryAddressScreen()),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION: UI Build Method
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Date')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ─────────────────────────────────────────────────────────
              // SUBSECTION: Scrollable Content Area with Summary Card
              // ─────────────────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [buildSummaryCard(), const SizedBox(height: 16)],
                  ),
                ),
              ),
              // ─────────────────────────────────────────────────────────
              // SUBSECTION: Bottom Navigation Buttons (Back and Next)
              // ─────────────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _proceed,
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
