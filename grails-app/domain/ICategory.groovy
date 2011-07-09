class ICategory extends Base{

    static constraints = {
    }

    static hasMany = [categories : ICategory]

}
