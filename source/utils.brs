
function utility()
    data = {

        '  ************* TO Change Organization Id change here **************

        organizationId: "557", ' Change value to some other value for different Organization
        nowcastLogo: "pkg:/images/launchScreen/nowcast_bottom_logo.png", ' App Logo which is displayed on bottom of splash screen
        ' This will move Nowcast logo up and down keeping the icon horizontally center
        nowcastLogoSpaceFromBottom: -30 ' Space from Bottom on the screen

        ' ******************* Splash Screen Configurations *******************

        'This is Maximum duration of splash screen any video will not play extending this duration
        maximumSplashScreenDuration: 20,

        ' This will be the minimum time on splash screen to be spent for buffer and
        ' start the video or to show the background image if video is not there and
        ' if there is video on splash screen then it will wait for 5 sec to buffer and
        ' if not buffered than it will be redirected to main screen and if there is only background image
        ' than that will only be there for 5 sec only
        ' note :- If video is buffured before 5 sec than this value will not affect tha Splash Screen video playing
        bufferWaitingTimeForSplashScreenVideo: 15


        ' *********************** Important Note: Banner Video and Background should be vice versa ******************************************

        ' Note:- Dont change isVideo , setVideoUrl , StreamFormat as these are working now from the server
        ' Functionality :- If Organization want splash screen video to be played on Splash Screen than it should upload
        ' splash screen video from web than splash screen video will be played and if Organization wants only background
        ' image on splash screen than it should not upload Splash screen Video on WEB insted he need to set the properties defined above
        ' backgroundBannerVisible as true and backgroundBannerUrl by placing the image in images folder and provide the path as shown above
        isVideo: m.global["isVideo"], 'this is to set the video Player on Splash Screen (true for play or false for hide)
        setVideoUrl: m.global["setVideoUrl"],
        streamFormat: "mp4" ' This is to set the format for the splash screen video


        'Organization Logo Setting
        orgLogoVisible: true, 'set organizationLogo visibility on Splash Screen (true for show or false for hide)
        orgLogoSplashScreen: "pkg:/images/launchScreen/Org 73 Logo.png" 'this is to set the organisation logo path , size width 470 , height 265px
        orgLogoForMainScreen: "pkg:/images/launchScreen/Org 73 Logo.png" ' this is the main logo for grid screen as an organization logo
        orgLogoSize: 400, ' Organization logo size
        ' This will move logo up and down keeping the icon horizontally center
        orgLogoPosition: 0, 'to move logo up and down provide value in -ve(Move Upward) and +ve(move Downward) 0 will be by default for center of the screen


        ' Login Screue we have to maintain the aspect Ratio
        ' to show that in actual dimensions
        ' Default valuen Configuration

        ' Logo is decided depending upon height of the logo not on the
        ' width becase is 200 change this to increase or decrease
        loginScreenLogoSize: 200,



        ' Note :- Not to be changed
        useBannerArtwork: false ' Using Banner Artwork true means to use bannerArtwork on Banner
        backgroundBannerVisible: false, 'this is to set the background Image on splash screen (true for show or false for hide)

    }
    return data
end function





