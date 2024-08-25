// SPDX-License-Identifier: MIT
pragma solidity >=0.7.10 <0.9.0;

contract CollegeCourseReviews {

    struct Review {
        address student;
        string collegeName;
        string courseName;
        string courseInstructor;
        uint8 instructorRating;
        uint8 taSupportRating;
        uint8 difficultyLevelRating;
        uint8 learningEnvironmentRating;
        uint8 courseMaterialsRating;
        uint8 classParticipationRating;
        uint8 overallRating;
        uint256 timestamp;
    }

    struct College {
        string collegeName;
        uint reviewCount;
        mapping(uint => Review) reviews;
        uint totalInstructorRating;
        uint totalTASupportRating;
        uint totalDifficultyLevelRating;
        uint totalLearningEnvironmentRating;
        uint totalCourseMaterialsRating;
        uint totalClassParticipationRating;
        uint totalOverallRating;
    }

    mapping(uint => College) public colleges;
    uint public collegeCount;

    uint256 public constant rewardTokens = 10;
    mapping(address => uint256) public tokenBalance;

    // Temporary storage for ratings before submission
    mapping(address => uint8) public instructorRating;
    mapping(address => uint8) public taSupportRating;
    mapping(address => uint8) public difficultyLevelRating;
    mapping(address => uint8) public learningEnvironmentRating;
    mapping(address => uint8) public courseMaterialsRating;
    mapping(address => uint8) public classParticipationRating;
    mapping(address => uint8) public overallRating;

    // Function to add a new college
    function addCollege(string memory _collegeName) public {
        collegeCount++;
        colleges[collegeCount].collegeName = _collegeName;
    }

    // Functions to set individual ratings by students
    function setInstructorRating(uint8 _rating) public {
        require(_rating > 0 && _rating <= 5, "Rating should be between 1 and 5");
        instructorRating[msg.sender] = _rating;
    }

    function setTASupportRating(uint8 _rating) public {
        require(_rating > 0 && _rating <= 5, "Rating should be between 1 and 5");
        taSupportRating[msg.sender] = _rating;
    }

    function setDifficultyLevelRating(uint8 _rating) public {
        require(_rating > 0 && _rating <= 5, "Rating should be between 1 and 5");
        difficultyLevelRating[msg.sender] = _rating;
    }

    function setLearningEnvironmentRating(uint8 _rating) public {
        require(_rating > 0 && _rating <= 5, "Rating should be between 1 and 5");
        learningEnvironmentRating[msg.sender] = _rating;
    }

    function setCourseMaterialsRating(uint8 _rating) public {
        require(_rating > 0 && _rating <= 5, "Rating should be between 1 and 5");
        courseMaterialsRating[msg.sender] = _rating;
    }

    function setClassParticipationRating(uint8 _rating) public {
        require(_rating > 0 && _rating <= 5, "Rating should be between 1 and 5");
        classParticipationRating[msg.sender] = _rating;
    }

    function setOverallRating(uint8 _rating) public {
        require(_rating > 0 && _rating <= 5, "Rating should be between 1 and 5");
        overallRating[msg.sender] = _rating;
    }

    // Function to submit the review and reward the student
    function submitReview(
        uint _collegeId,
        string memory _collegeName,
        string memory _courseName,
        string memory _courseInstructor
    ) public {
        require(bytes(_collegeName).length > 0, "College name is required");
        require(bytes(_courseName).length > 0, "Course name is required");
        require(bytes(_courseInstructor).length > 0, "Course instructor is required");
        
        College storage college = colleges[_collegeId];
        uint reviewId = college.reviewCount++;

        Review storage review = college.reviews[reviewId];
        review.student = msg.sender;
        review.collegeName = _collegeName;
        review.courseName = _courseName;
        review.courseInstructor = _courseInstructor;
        review.instructorRating = instructorRating[msg.sender];
        review.taSupportRating = taSupportRating[msg.sender];
        review.difficultyLevelRating = difficultyLevelRating[msg.sender];
        review.learningEnvironmentRating = learningEnvironmentRating[msg.sender];
        review.courseMaterialsRating = courseMaterialsRating[msg.sender];
        review.classParticipationRating = classParticipationRating[msg.sender];
        review.overallRating = overallRating[msg.sender];
        review.timestamp = block.timestamp;

        // Update aggregate ratings for the college
        college.totalInstructorRating += review.instructorRating;
        college.totalTASupportRating += review.taSupportRating;
        college.totalDifficultyLevelRating += review.difficultyLevelRating;
        college.totalLearningEnvironmentRating += review.learningEnvironmentRating;
        college.totalCourseMaterialsRating += review.courseMaterialsRating;
        college.totalClassParticipationRating += review.classParticipationRating;
        college.totalOverallRating += review.overallRating;

        // Reward the student with tokens
        tokenBalance[msg.sender] += rewardTokens;

        // Clear the temporary storage for the student
        delete instructorRating[msg.sender];
        delete taSupportRating[msg.sender];
        delete difficultyLevelRating[msg.sender];
        delete learningEnvironmentRating[msg.sender];
        delete courseMaterialsRating[msg.sender];
        delete classParticipationRating[msg.sender];
        delete overallRating[msg.sender];

        emit ReviewSubmitted(msg.sender, _collegeId, reviewId);
    }

    // Function to get the overall review for a particular college
    function getOverallReview(uint _collegeId) public view returns (
        uint totalInstructorRating,
        uint totalTASupportRating,
        uint totalDifficultyLevelRating,
        uint totalLearningEnvironmentRating,
        uint totalCourseMaterialsRating,
        uint totalClassParticipationRating,
        uint totalOverallRating
    ) {
        College storage college = colleges[_collegeId];
        return (
            college.totalInstructorRating,
            college.totalTASupportRating,
            college.totalDifficultyLevelRating,
            college.totalLearningEnvironmentRating,
            college.totalCourseMaterialsRating,
            college.totalClassParticipationRating,
            college.totalOverallRating
        );
    }

    // Function to provide tokens to the student
    function provideTokens(address _student) public {
        require(tokenBalance[_student] > 0, "Student has no tokens to provide");
        // Simple token transfer mechanism within this contract
        // In a real application, you would interact with an ERC20 token contract
        uint256 tokens = tokenBalance[_student];
        tokenBalance[_student] = 0; // Reset balance after transfer
        // Transfer tokens logic should be here
        // For demonstration purposes, we'll just simulate token transfer
        emit TokensProvided(_student, tokens);
    }

    event ReviewSubmitted(address indexed student, uint indexed collegeId, uint reviewId);
    event TokensProvided(address indexed student, uint256 amount);
}

