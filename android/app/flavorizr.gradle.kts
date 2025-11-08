import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("client") {
            dimension = "flavor-type"
            applicationId = "top.foodie.client"
            resValue(type = "string", name = "app_name", value = "DZ-NAT")
        }
        create("owner") {
            dimension = "flavor-type"
            applicationId = "top.foodie.owner"
            resValue(type = "string", name = "app_name", value = "DZ-NAT OWNER")
        }
        create("server") {
            dimension = "flavor-type"
            applicationId = "top.foodie.server"
            resValue(type = "string", name = "app_name", value = "DZ-NAT SERVER")
        }
    }
}