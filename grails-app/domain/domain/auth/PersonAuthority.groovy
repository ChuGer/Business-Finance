package domain.auth

import org.apache.commons.lang.builder.HashCodeBuilder
import domain.User

class PersonAuthority implements Serializable {

	User person
	Authority authority

	boolean equals(other) {
		if (!(other instanceof PersonAuthority)) {
			return false
		}

		other.person?.id == person?.id &&
			other.authority?.id == authority?.id
	}

	int hashCode() {
		def builder = new HashCodeBuilder()
		if (person) builder.append(person.id)
		if (authority) builder.append(authority.id)
		builder.toHashCode()
	}

	static PersonAuthority get(long personId, long authorityId) {
		find 'from PersonAuthority where person.id=:personId and authority.id=:authorityId',
			[personId: personId, authorityId: authorityId]
	}

	static PersonAuthority create(User person, Authority authority, boolean flush = false) {
		new PersonAuthority(person: person, authority: authority).save(flush: flush, insert: true)
	}

	static boolean remove(User person, Authority authority, boolean flush = false) {
		PersonAuthority instance = PersonAuthority.findByPersonAndAuthority(person, authority)
		instance ? instance.delete(flush: flush) : false
	}

	static void removeAll(User person) {
		executeUpdate 'DELETE FROM PersonAuthority WHERE person=:person', [person: person]
	}

	static void removeAll(Authority authority) {
		executeUpdate 'DELETE FROM PersonAuthority WHERE authority=:authority', [authority: authority]
	}

	static mapping = {
		id composite: ['authority', 'person']
		version false
	}
}
