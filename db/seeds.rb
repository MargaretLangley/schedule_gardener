# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])

AppointmentSlot.create(time: '09:30', humanize_time: 'Early Morning - (9.30 am)', value: 570)
AppointmentSlot.create(time: '11:30', humanize_time: 'Late Morning - (11.30 am)', value: 690)
AppointmentSlot.create(time: '13:30', humanize_time: 'Early Afternoon - (1.30pm)', value: 810)
AppointmentSlot.create(time: '15:30', humanize_time: 'Late Afternoon - (3.30 pm)', value: 930)
