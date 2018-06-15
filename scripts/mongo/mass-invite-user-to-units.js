//////////////////////////////////////////////
// This scripts is made to assign a single 
// user to a role in multiple units
//////////////////////////////////////////////
//////////////////////////////////////////////

//////////////////////////////////////////////
// This is where you set the variables
//////////////////////////////////////////////

// Set the invitor's bz id
var invitorId = -1;

// Set the invitee's bz id
var inviteeId = -1;

// Set the invitee's role in the new units (should match a value from ut_role_types)
var role = 'Agent';

// Set whether the invitee is the occupant of the units (true/false)
var isOccupant = false;

// Set the units' bz ids
var unitIds = [
  1,
  2,
  3
];

// Set the invitation type. This has to match a value from ut_invitation_types.
// The default of 'keep_default' will invite a user to a role without removing others
var invitationType = 'keep_default'; // Only this value should be used until further testing is done on MEFE

///////////////////////////////////////////////
// Just code from here onwards, don't change it
///////////////////////////////////////////////

print('Mass user->units assignment has started');
print('Retrieving invitee and invitor information');
var invitee = db.users.findOne({
  'bugzillaCreds.id': inviteeId
})
var invitor = db.users.findOne({
  'bugzillaCreds.id': invitorId
})
unitIds.forEach(id => {
  print('Assigning for unit ' + id + '...');

  // First we're checking if the user has an existing invitation to this unit, so we avoid double invitation scenarios,
  //   while still allowing the rest of the invitations to be created
  if (invitee.receivedInvites) {
    var conflictingInvitations = invitee.receivedInvites.filter(inv => inv.unitId === id);
    if (conflictingInvitations.length) {
      print('The user is already invited to unit ' + id + ', skipping invitation');
      return;
    }
  }
  print('Creating pending invitation...');
  var result = db.pendingInvitations.insertOne({
    invitedBy: invitorId,
    invitee: inviteeId,
    role: role,
    isOccupant: isOccupant,
    unitId: id,
    type: invitationType
  })
  print('Linking invitation to user...');
  db.users.update({
    _id: invitee._id
  }, {
    $push: {
      receivedInvites: {
        invitationId: result.insertedId,
        role: role,
        isOccupant: isOccupant,
        unitId: id,
        invitedBy: invitor._id,
        timestamp: Date.now(),
        type: invitationType
      }
    }
  })
  print('The user\'s invitation to unit ' + id + ' was successfully created');
});
