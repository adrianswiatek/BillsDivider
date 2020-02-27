import CoreData

extension Person {
    func asPersonEntity(orderNumber: Int, context: NSManagedObjectContext) -> PersonEntity {
        let entity = PersonEntity(context: context)
        entity.id = self.id
        entity.name = self.name
        entity.state = self.state.rawValue
        entity.color = self.colors.background.rawValue
        entity.orderNumber = Int32(orderNumber)
        return entity
    }
}

extension PersonEntity {
    func asPerson() -> Person {
        guard
            let id = self.id,
            let name = self.name,
            let state = Person.State(rawValue: self.state ?? ""),
            let colors = personColors()
        else { preconditionFailure("Unable to create Person from entity") }

        return .init(id: id, name: name, state: state, colors: colors)
    }

    private func personColors() -> PersonColors? {
        guard let color = self.color, let bdColor = BDColor(rawValue: color) else {
            return nil
        }

        return .fromColor(bdColor)
    }
}
