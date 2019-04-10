# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

p "Starting seeding the database"
ArmorType.delete_all
ClassType.delete_all
ArmorType.create(value: "Cloth")
ArmorType.create(value: "Leather")
ArmorType.create(value: "Mail")
ArmorType.create(value: "Plate")

ClassType.create([ { value: 'Mage' }, { value: 'Priest' }, { value: 'Warlock' }, { value: 'Demon Hunter' }, { value: 'Druid' }, { value: 'Monk' }, { value: 'Rogue' }, { value: 'Hunter' }, { value: 'Shaman' }, { value: 'Death Knight' }, { value: 'Paladin' }, { value: 'Warrior' }])
p "Finished seeding the database with ArmorTypes and Character Class types"